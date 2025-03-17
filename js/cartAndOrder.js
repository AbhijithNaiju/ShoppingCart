$(document).ready(function(){ 
	$('.removeButton').click(function(){
		const cartId = this.value;
		Swal.fire({
			title: "Are you sure?",
			text: "This product will be removed from the cart.",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: "Remove"
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"components/cart.cfc",
					data:{
						cartId:cartId,
						method:"removeFromCart"
					},
					success: function(result) {
						cartDeleteResult=JSON.parse(result)
						if(cartDeleteResult.success){
							// updating total price
							cartItem = $("#cartItem"+$.escapeSelector(cartId))
							itemPrice = parseFloat($(cartItem).find(".itemPrice").text());
							itemTax = parseFloat($(cartItem).find(".itemTax").text());
							itemQuantity = parseFloat($(cartItem).find(".cartQuantity").val());

							actualPriceElement = $('#actualPrice');
							totalTaxElement = $('#totalTax');
							totalPriceElement = $('#totalPrice');

							updatedActualPrice = (parseFloat(actualPriceElement.text())-(itemPrice*itemQuantity)).toFixed(2);
							updatedTotalTax = (parseFloat(totalTaxElement.text())-(itemTax*itemQuantity)).toFixed(2);
							updatedTotalPrice = parseFloat(updatedActualPrice) + parseFloat(updatedTotalTax);

							actualPriceElement.text(updatedActualPrice);
							totalTaxElement.text(updatedTotalTax);
							totalPriceElement.text(updatedTotalPrice);

							// removing deleted item
							cartItem.remove();

							// Changing cart count
							$("#cartCount").text(cartDeleteResult.cartCount);
							if(cartDeleteResult.cartCount == 0){
								location.reload();
							}
						}else{
							Swal.fire({
							position: "top",
							toast: true,
							icon: "error",
							title: "Error occured please try again",
							showConfirmButton: false,
							timer: 1500
						});
						}
					},error: function(){
						alert("Error occured");
					}
				});
			}
		});
	});
	
	// Setting reduce quantity buttons disabled if quantity is 1
	$(function() {
		if($(".cartQuantity")){
			quantityItems = $(".cartQuantity");
			for(let element of quantityItems){
				if($(element).val()==1){
					$(element).prev().prop("disabled",true);
				}
			};
		}
	});

	$(".orderAddress").change(function(){
		const addressId=this.value;
		$("#orderAddressId").val(addressId);
		addressItem=$("#addressItem"+addressId);
		$("#selectedAddress").empty()
		$("#selectedAddress").append(addressItem.find(".addressName").clone())
		$("#selectedAddress").append(addressItem.find(".addressDetails").clone())
		$("#selectedAddress").append(addressItem.find(".addressPhone").clone())
		$("#changeAddressModal").modal("hide");
	});

	$("#placeOrderForm").submit(function(){
		$("#cardError").hide();
		const orderAddressId=$("#orderAddressId").val();
		const cardNumber=$("#cardNumber").val();
		const cardCVV=$("#cardCVV").val();
		let isError=false;
		if(!orderAddressId || orderAddressId.length==0){
			Swal.fire({
				position: "top",
				toast: true,
				icon: "error",
				title: "Please enter address to continue",
				showConfirmButton: false,
				timer: 1500
			});
			isError=true;
		}
		if(cardNumber.length==0){
			setError(message = "Please enter the 16 digit card number",messageLocationId = "cardNumberError");
			isError=true;
		}else{
			setSuccess("cardNumberError")
		}
		if(cardCVV.length==0){
			setError(message = "Please enter 3 digit card cvv",messageLocationId = "cardCVVError");
			isError=true;
		}else{
			setSuccess("cardCVVError")
		}
		if(isError){
			return false;
		}
	});
	$(".reduceQuantity").click(function(){
		cartId=this.value;
		changeQuantity(change=-1,cartId=this.value);
	});
	$(".increaseQuantity").click(function(){
		cartId=this.value;
		changeQuantity(change=1,cartId=this.value);
	});
});

function changeQuantity(change,cartId){
	$.ajax({
		type:"POST",
		url:"components/cart.cfc?method=updateCartQnty",
		data:{
			cartId:cartId,
			quantityChange:change
		},
		success: function(result){
			changeQuantityResult=JSON.parse(result)
				quantityElement= $("#quantityButton"+$.escapeSelector(cartId)).find(".cartQuantity");
			if(changeQuantityResult.cartItemQuantity){
				quantityElement.val(changeQuantityResult.cartItemQuantity);
				if(changeQuantityResult.cartItemQuantity==1){
					// disabling reduce button
					$("#quantityButton"+$.escapeSelector(cartId)).find(".reduceQuantity").prop("disabled",true);
				}
				if(changeQuantityResult.cartItemQuantity==2){
					// enabling reduce button
					$("#quantityButton"+$.escapeSelector(cartId)).find(".reduceQuantity").prop("disabled",false);
				}
			}
			if(changeQuantityResult.success){
				// setting total price
				actualPriceElement = $('#actualPrice');
				totalTaxElement = $('#totalTax');
				totalPriceElement = $('#totalPrice');

				if(change == -1){
					updatedActualPrice = (parseFloat(actualPriceElement.text())-(changeQuantityResult.unitPrice)).toFixed(2);
					updatedTotalTax = (parseFloat(totalTaxElement.text())-(changeQuantityResult.unitTax)).toFixed(2);
				}else{
					updatedActualPrice = (parseFloat(actualPriceElement.text())+(changeQuantityResult.unitPrice)).toFixed(2);
					updatedTotalTax = (parseFloat(totalTaxElement.text())+(changeQuantityResult.unitTax)).toFixed(2);
				}
				updatedTotalPrice = (parseFloat(updatedActualPrice) + parseFloat(updatedTotalTax)).toFixed(2);

				actualPriceElement.text(updatedActualPrice);
				totalTaxElement.text(updatedTotalTax);
				totalPriceElement.text(updatedTotalPrice);
			}else if(changeQuantityResult.error){
				Swal.fire({
					position: "top",
					toast: true,
					icon: "error",
					title: changeQuantityResult.error,
					showConfirmButton: false,
					timer: 1500
				});
			}else{
				alert("An unexpected error occured");
			}
		},error: function(){
			alert("Error occured");
		}
	});
}