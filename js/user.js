$(document).ready(function(){ 
	setCartCount();
	function setCartCount(){
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=headerDetails",
			success: function(result) {
				headerDetails=JSON.parse(result)
				if(headerDetails.sessionExist){
					$("#cartCount").show();
					$("#cartCount").text(headerDetails.cartCount);
				}else{
					emptyHeader();
				}
			}
		});
	}

	$('.filterInput').click(function(){
		$('[name=filterRadio]').prop('checked',false);
	});


	$('.removeButton').click(function(){
		const cartId = $(this).val();
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=removeFromCart",
			data:{cartId:cartId},
			success: function(result) {
				cartDeleteResult=JSON.parse(result)
				if(cartDeleteResult.success){
					// updating total price
					cartItem = $("#cartItem"+cartId)
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
					newCartCount = parseInt($("#cartCount").text())-1;
					$("#cartCount").text(newCartCount);
					if(newCartCount == 0){
						$("#placeOrder").remove();
						// Showing message to goto home
						alert("No products remaining in cart, add products to continue.")
						location.href="./index.cfm"	
					}
				}else{
					alert("Error occured")
				}
			}
		});
	});
	
	// Setting reduce buttons disabled if quantity is 1
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

	$("#openProfileEdit").click(function(){
		$("#profileModal").addClass('profileEditModal');
		$("#profileModal").removeClass('displayNone');
		$("#profileEditBody").removeClass('displayNone');
	});

	$("#addAddress").click(function(){
		$("#profileModal").addClass('profileEditModal');
		$("#profileModal").removeClass('displayNone');
		$("#addAddressBody").removeClass('displayNone');
	});

	$(".closeProfileEdit").click(function(){
		$("#profileModal").addClass('displayNone');
		$("#profileModal").removeClass('profileEditModal');
		$("#profileEditBody").addClass('displayNone');
		$("#addAddressBody").addClass('displayNone');
		$("#updateProfileError").text('');
		$("#updateProfileSuccess").text('');
	});

	$("#changeAddress").click(function(){
		$("#selectAddressModal").addClass('profileEditModal');
		$("#selectAddressModal").removeClass('displayNone');
	});

	$("#closeSelectAddress").click(function(){
		$("#selectAddressModal").removeClass('profileEditModal');
		$("#selectAddressModal").addClass('displayNone');
	});

	$("#orderAddAddress").click(function(){
		$("#addAddressModal").addClass('profileEditModal');
		$("#addAddressModal").removeClass('displayNone');
	});

	$("#closeAddAddress").click(function(){
		$("#addAddressModal").removeClass('profileEditModal');
		$("#addAddressModal").addClass('displayNone');
	});

	$(".deleteAddress").click(function(){
		const addressId=this.value;
		if(confirm("This address will be deleted from your profile")){
			$.ajax({
				type:"POST",
				url:"components/user.cfc?method=deleteAddress",
				data:{addressId:addressId},
				success: function(result) {
					logOutResult=JSON.parse(result)
					if(logOutResult.success){
						$("#address"+addressId).remove();
					}
				}
			});
		}
	});

	$(".orderAddress").change(function(){
		const addressId=this.value;
		addressItem=$("#addressItem"+addressId)
		$("#selectedAddress").empty()
		$("#selectedAddress").append(addressItem.find(".addressName").clone())
		$("#selectedAddress").append(addressItem.find(".addressDetails").clone())
		$("#selectedAddress").append(addressItem.find(".addressPhone").clone())
	});
	
	$("#buyNow").click(function(){
		productId=this.value;
		addToCart(productId,"order");
		location.href="./orderPage.cfm"
	})

	$("#editProfileForm").submit(function(){
		let firstName= $("#firstName").val();
		let lastName= $("#lastName").val();
		let emailId= $("#emailId").val();
		let phoneNumber= $("#phoneNumber").val();
		let userId= $("#editProfile").val();
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=updateProfile",
			data:{
				userId:userId,
				firstName:firstName,
				lastName:lastName,
				emailId:emailId,
				phoneNumber:phoneNumber
			},
			success: function(result) {
				editProfileResult=JSON.parse(result)
				if(editProfileResult.success){

					$("#profileName").text(firstName +' '+lastName);
					$("#profileEmail").text(emailId);

					$("#updateProfileSuccess").text("Profile edited successfully");
					$("#updateProfileError").text("");
				}else if(editProfileResult.error){
					$("#updateProfileError").text(editProfileResult.error);
					$("#updateProfileSuccess").text("");
				}
			}
		});
		return false;
	})
});

function emptyHeader(){
	$("#logOutBtn").text("Login")
	$("#cartCount").hide()
	$("#cartBtn").attr('href',"login.cfm?redirect=cart")
	$("#profileBtn").attr('href', "login.cfm?redirect=profilePage")
	$("#logOutBtn").attr('onclick','location.href = "login.cfm"')
}

function logOut(){
	if(confirm("You will log out of this page and need to authenticate again to login")){
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=logOut",
			success: function(result) {
				logOutResult=JSON.parse(result)
				if(logOutResult.success){
					location.reload();
				}
			}
		});
	}
}

function setFilter(range){
	$('#filterMin').val(range.min)
	$('#filterMax').val(range.max)
}

function clearFilter(){
	setFilter({min:'',max:''});
	$('[name=filterRadio]').prop('checked',false);
}

function filterProducts(currentData){
	let minValue = $("#filterMin").val();
	let maxValue = $("#filterMax").val();
	const filterData = new Object();
	if(minValue < 0 || maxValue < 0){
		$("#filterError").text("Please enter a positive number");
	}else{
		$("#filterError").text("");
		if(minValue.trim().length == 0){
			minValue = -1
		}
		if(maxValue.trim().length == 0){
			maxValue = -1
		}
		filterData.minPrice = minValue;
		filterData.maxPrice = maxValue;
		if(currentData.subcategoryId){
			filterData.subcategoryId = currentData.subcategoryId;
		}else if(currentData.searchValue != ''){
			filterData.searchValue = currentData.searchValue;
		}
		filterData.sortOrder = currentData.sortOrder;
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=getProductList",
			data:filterData,
			success: function(result) {
				$('#productListingParent').empty();
				$("#showMoreBtn").css("display","none");

				productList=JSON.parse(result)
				if(productList.resultArray.length){
					$('#listingMessage').text("");
					listProducts(productList.resultArray)
				}else{
					$('#listingMessage').text("No products Found");
				}	
			}
		});
		$(".dropdown-toggle").dropdown('toggle');
	}
}

function listProducts(productList){
	productList.forEach(productData => {
		let productBody = `
			<a 
				href="product.cfm?productId=${productData.productId}" 
				class="randomProducts p-3 d-flex flex-column align-items-center border"
			>
				<img src="./assets/productimages/${productData.imageFileName}"></img>
				<div class="w-100 my-2">
					<h6>${productData.productName}</h6>
					<p>${productData.brandName}</p>
					<p class="mt-auto">Rs : ${productData.productPrice+productData.productTax}</p>
				</div>
			</a>
		`;
		$("#productListingParent").append(productBody);
	});
}

function addToCart(productId,redirect){
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=addToCart",
		data:{productId:productId},
		success: function(result) {
			addToCartResult=JSON.parse(result)
			if(addToCartResult.redirect){
				if(redirect && redirect==="order"){
					location.href="login.cfm?redirect=order&productId="+productId
				}else{
					location.href="login.cfm?redirect=cart&productId="+productId
				}
			}else{
				$("#productMessages").text("Product added to cart")
				if(addToCartResult.increasedItemCount){
					let newCartCount=parseInt($("#cartCount").text())+addToCartResult.increasedItemCount;
					$("#cartCount").text(newCartCount);
				}
			}
		}
	});
}

function showMore(currentData)
{
	const productData = new Object();
	if(currentData.subcategoryId){
		productData.subcategoryId = currentData.subcategoryId;
	}else if(currentData.searchValue != ''){
		productData.searchValue = currentData.searchValue;
	}
	productData.sortOrder = currentData.sortOrder;
	productData.excludedIdList = currentData.excludedIdList;

	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=getProductList",
		data:productData,
		success: function(result) {
			resultJson=JSON.parse(result);
			listProducts(resultJson.resultArray)
			$("#showMoreBtn").css("display","none")
		}
	});
}

function changeQuantity(buttonObject,changeDetails){
	if(changeDetails.change == -1){
		quantityElement= $(buttonObject).next();
		newQuantity = parseInt(quantityElement.val())-1
		if(newQuantity==1){
			// disabling reduce button
			$(buttonObject).prop("disabled",true);
		}
	}else{
		quantityElement= $(buttonObject).prev();
		newQuantity = parseInt(quantityElement.val())+1
		if(newQuantity==2){
			// disabling reduce button
			$(quantityElement).prev().prop("disabled",false)
		}
	}
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=updateCartQnty",
		data:{
			cartId:changeDetails.cartId,
			quantityChange:changeDetails.change
		},
		success: function(result){
			changeQuantityResult=JSON.parse(result)
			if(changeQuantityResult.success){
				// setting input value
				quantityElement.val(newQuantity);

				// setting total price
				cartItem = $("#cartItem"+changeDetails.cartId)
				itemPrice = parseFloat($(cartItem).find(".itemPrice").text());
				itemTax = parseFloat($(cartItem).find(".itemTax").text());
				
				actualPriceElement = $('#actualPrice');
				totalTaxElement = $('#totalTax');
				totalPriceElement = $('#totalPrice');

				if(changeDetails.change == -1){
					updatedActualPrice = (parseFloat(actualPriceElement.text())-(itemPrice)).toFixed(2);
					updatedTotalTax = (parseFloat(totalTaxElement.text())-(itemTax)).toFixed(2);
				}else{
					updatedActualPrice = (parseFloat(actualPriceElement.text())+(itemPrice)).toFixed(2);
					updatedTotalTax = (parseFloat(totalTaxElement.text())+(itemTax)).toFixed(2);
				}
				updatedTotalPrice = (parseFloat(updatedActualPrice) + parseFloat(updatedTotalTax)).toFixed(2);

				actualPriceElement.text(updatedActualPrice);
				totalTaxElement.text(updatedTotalTax);
				totalPriceElement.text(updatedTotalPrice);
			}
		}
	});
}