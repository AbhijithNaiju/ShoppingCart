$(document).ready(function(){ 
	setCartCount();

	// Used to unselect radio when custom min max are used
	$('.filterInput').click(function(){
		$('[name=filterRadio]').prop('checked',false);
	});

	$('.removeButton').click(function(){
		const cartId = $(this).val();
		Swal.fire({
			title: "Are you sure?",
			text: "This product will be removed from the cart!",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: "Remove"
		}).then((result) => {
			if (result.isConfirmed) {
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
							$("#cartCount").text(cartDeleteResult.cartCount);
							if(cartDeleteResult.cartCount == 0){
								$("#placeOrder").remove();
								// Showing message to goto home
								Swal.fire({
									title: "Message !",
									text: "No products remaining in cart, add products to continue. !",
									icon: "info"
								  }).then((result)=>{
									  location.href="./index.cfm"	
								  });
							}
						}else{
							alert("Error occured please try again");
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
					$(element).prev().prop("disabled",true); //Only this line of code is reusable
				}
			};
		}
	});

	$(".closeProfileEdit").click(function(){
		$("#updateProfileError").text('');
	});

	$(".deleteAddress").click(function(){
		const addressId=this.value;
		Swal.fire({
			title: "Are you sure?",
			text: "This address will be deleted from your profile!",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: "Delete"
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"components/user.cfc?method=deleteAddress",
					data:{addressId:addressId},
					success: function(result) {
						logOutResult=JSON.parse(result)
						if(logOutResult.success){
							$("#address"+addressId).remove();
						}else{
							Swal.fire({
								title: "Error occured while deleting!",
								text: "Please try again.",
								icon: "error"
							  });
						}
					},error: function(){
						alert("Error occured");
					}
				});
			}
		});
	});

	$(".orderAddress").change(function(){
		const addressId=this.value;
		$("#orderAddressId").val(addressId);
		addressItem=$("#addressItem"+addressId);
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
		event.preventDefault()
		let firstName= $("#firstName").val();
		let lastName= $("#lastName").val();
		let emailId= $("#emailId").val();
		let phoneNumber= $("#phoneNumber").val();
		let userId= $("#editProfile").val();

		let isFirstNameValid = checkSpecialCharector(firstName,"firstNameError");
		let isLastNameValid = checkSpecialCharector(lastName,"lastNameError");
		let isEmailValid = validateEmail(emailId,"emailError");
		let isPhoneValid = validatePhoneNumber(phoneNumber,"phoneNumberError");
		if(isFirstNameValid &&
			isLastNameValid &&
			isEmailValid &&
			isPhoneValid
		){
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

						$("#firstName").attr("value",firstName);
						$("#lastName").attr("value",lastName);
						$("#emailId").attr("value",emailId);
						$("#phoneNumber").attr("value",phoneNumber);
						$("#profileEditModal").modal("hide");
						Swal.fire({
							position: "top-end",
							toast: true,
							icon: "success",
							title: "Profile edited successfully",
							showConfirmButton: false,
							timer: 1500
						});
						$("#updateProfileError").text("");
					}else if(editProfileResult.error){
						$("#updateProfileError").text(editProfileResult.error);
					}
				},error: function(){
					alert("Error occured");
				}
			});
			return false;
		}
	});
	$("#addAddressForm").submit(function(){
		let addressFirstName= $("#addressFirstName").val();
		let addressLastName= $("#addressLastName").val();
		let addressLine1= $("#addressLine1").val();
		let addressLine2= $("#addressLine2").val();
		let city= $("#city").val();
		let state= $("#state").val();
		let addressPhoneNumber= $("#addressPhoneNumber").val();
		let pincode= $("#pincode").val();

		let isaddressFirstNameValid = checkSpecialCharector(addressFirstName,"FirstNameError");
		let isaddressLastNameValid = checkSpecialCharector(addressLastName,"LastNameError");
		let isaddressLine1Valid = checkSpecialCharector(addressLine1,"addressLine1Error");
		let isaddressLine2Valid = checkSpecialCharector(addressLine2,"addressLine2Error");
		let iscityValid = checkSpecialCharector(city,"cityError");
		let isstateValid = checkSpecialCharector(state,"stateError");
		let isaddressPhoneNumberValid = validatePhoneNumber(addressPhoneNumber,"addressPhoneNumberError");
		let ispincodeValid = checkSpecialCharector(pincode,"pincodeError");
		if(isaddressFirstNameValid &&
			isaddressLastNameValid &&
			isaddressLine1Valid &&
			isaddressLine2Valid &&
			iscityValid &&
			isstateValid &&
			isaddressPhoneNumberValid &&
			ispincodeValid
		){
			return true;
		}else{
			return false;
		}
	});
	
	$("#orderSearchClearButton").click(function(){
		$("#orderSearchField").val('');
	});

	$("#signupForm").submit(function(){
		let firstName =$("#firstName").val();
		let lastName =$("#lastName").val();
		let emailId =$("#emailId").val();
		let phoneNumber =$("#phoneNumber").val();
		let password =$("#password").val();
		let confirmPassword =$("#confirmPassword").val();

		let isFirstNameValid = checkSpecialCharector(firstName,"firstNameError");
		let isLastNameValid = checkSpecialCharector(lastName,"lastNameError");
		let isEmailValid = validateEmail(emailId,"emailError");
		let isPhoneValid = validatePhoneNumber(phoneNumber,"phoneNumberError");
		let isPasswordValid = validatePassword(password,"passwordError");
		let isConfirmValid = confirmPasswords(password,confirmPassword,"confirmPasswordError");
		if(isFirstNameValid &&
			isLastNameValid &&
			isEmailValid &&
			isPhoneValid &&
			isPasswordValid &&
			isConfirmValid){	
				return true;
			}else{
				return false;
			}
	})
});

function setCartCount(){
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=headerDetails",
		success: function(result) {
			headerDetails=JSON.parse(result)
			if(headerDetails.sessionExist){
				$("#cartCount").show();
				$("#cartCount").text(headerDetails.cartCount);
				return headerDetails.cartCount;
			}else{
				emptyHeader();
			}
		},error: function(){
			alert("Error occured");
		}
	});
}
function emptyHeader(){
	$("#logOutBtn").text("Login")
	$("#cartCount").hide()
	$("#cartBtn").attr('href',"login.cfm?redirect=cart")
	$("#profileBtn").attr('href', "login.cfm?redirect=profilePage")
	$("#logOutBtn").attr('onclick','location.href = "login.cfm"')
}

function logOut(){
	Swal.fire({
		title: "Are you sure?",
		text: "You will log out of this page and need to authenticate again to login",
		icon: "warning",
		showCancelButton: true,
		confirmButtonColor: "#3085d6",
		cancelButtonColor: "#d33",
		confirmButtonText: "Logout"
	  }).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				type:"POST",
				url:"components/user.cfc?method=logOut",
				success: function(result) {
					logOutResult=JSON.parse(result)
					if(logOutResult.success){
						location.reload();
					}
					else{
						Swal.fire({
							title: "Error!",
							text: "Please try again.",
							icon: "error"
						  });
					}
				},error: function(){
					alert("Error occured");
				}
			});
		}
	});
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
		$("#filterMin").attr("value",minValue);
		$("#filterMax").attr("value",maxValue);
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
		filterData.clearProducts=true;
		listProducts(filterData);
	}
}

if(myDropdown = document.getElementById('filterDropdown')){
	myDropdown.addEventListener('hide.bs.dropdown', event => {
		document.getElementById("dropdownForm").reset();
	})
}

function listProducts(currentData)
{
	let excludedList = $("#showMoreBtn");
	const productData = new Object();
	let minValue = $("#filterMin").val();
	let maxValue = $("#filterMax").val();
	if(minValue.trim().length == 0){
		minValue = -1
	}
	if(maxValue.trim().length == 0){
		maxValue = -1
	}
	if(currentData.subcategoryId){
		productData.subcategoryId = currentData.subcategoryId;
	}else if(currentData.searchValue != ''){
		productData.searchValue = currentData.searchValue;
	}
	if(minValue){
		productData.minPrice = minValue;
	}
	if(maxValue){
		productData.maxPrice = maxValue;
	}
	productData.sortOrder = currentData.sortOrder;
	if(currentData.clearProducts){
		productData.limit = 10;
		productData.count = true;
	}else{
		productData.limit = 5;
		productData.excludedIdList = excludedList.val();
	}
	
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=getProductList",
		data:productData,
		success: function(result) {
			resultJson=JSON.parse(result);
			if(currentData.clearProducts){
				// Removing current products
				$('#productListingParent').empty();
				excludedList.val('');
				$(".dropdown-toggle").dropdown('toggle');
			}
			if(resultJson.productCount){
				$("#totalProductCount").val(resultJson.productCount);	
			}
			let totalProductCount=parseInt($("#totalProductCount").val());
			if(resultJson.success){
				if(resultJson.resultArray.length){
					$('#listingMessage').text("");
					productIdList=[];
					resultJson.resultArray.forEach(productData => {
						let productBody = `
							<a 
								href="product.cfm?productId=${productData.productId}" 
								class="randomProducts d-flex flex-column justify-content-between align-items-center border shadow-sm"
							>
								<div class="card-img-top randomProductImage d-flex align-items-center justify-content-center">
									<img src="./assets/productimages/${productData.imageFileName}"></img>
								</div>
								<div class="w-100 d-flex flex-column randomProductsDetails">
									<h6 class="card-title p-2">${productData.productName}</h6>
									<span class = "productBrand text-secondary px-2">${productData.brandName}</span>
									<span class="mt-auto px-2 randomProductPrice">
										Rs : ${productData.productPrice+productData.productTax}
									</span>
								</div>
							</a>
						`;
						if(excludedList.val().length==0){
							excludedList.val(productData.productId);
						}else{
							excludedList.val(excludedList.val() + ',' +productData.productId);
						}
						$("#productListingParent").append(productBody);
					});
					if(totalProductCount == excludedList.val().split(",").length){
						excludedList.hide();
					}else{
						excludedList.show();
					}
				}else{
					excludedList.hide();
					if(!currentData.clearProducts){
						Swal.fire({
							position: "top",
							toast: true,
							icon: "error",
							title: "No products found",
							showConfirmButton: false,
							timer: 1500
						});
					}
				}
			}else{
				alert("Error occured while loading products");
			}
			if(currentData.clearProducts){
				if(resultJson.resultArray.length==0){
					$('#listingMessage').text("No products found");
				}
			}
		},error: function(){
			alert("Error occured");
		}
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
				Swal.fire({
					position: "top",
					toast: true,
					icon: "success",
					title: "Product added to cart",
					showConfirmButton: false,
					timer: 1500
				  });
				if(addToCartResult.increasedItemCount){
					setCartCount();
				}
			}
		},error: function(){
			alert("Error occured");
		}
	});
}

function changeQuantity(change,cartId){
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=updateCartQnty",
		data:{
			cartId:cartId,
			quantityChange:change
		},
		success: function(result){
			changeQuantityResult=JSON.parse(result)
				quantityElement= $("#quantityButton"+cartId).find(".cartQuantity");
			if(changeQuantityResult.cartItemQuantity){
				quantityElement.val(changeQuantityResult.cartItemQuantity);
				if(changeQuantityResult.cartItemQuantity==1){
					// disabling reduce button
					$("#quantityButton"+cartId).find(".reduceQuantity").prop("disabled",true);
				}
				if(changeQuantityResult.cartItemQuantity==2){
					// enabling reduce button
					$("#quantityButton"+cartId).find(".reduceQuantity").prop("disabled",false);
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