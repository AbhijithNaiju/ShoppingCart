$(document).ready(function(){

	setHeader();
	function setHeader(){
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=headerDetails",
			success: function(result) {
				headerDetails=JSON.parse(result)
				if(headerDetails.sessionExist){
					$("#cartCount").show()
					$("#cartCount").text(headerDetails.cartCount)
					$("#logOutBtn").text("Logout")
					$("#cartBtn").attr('onclick','location.href="cartPage.cfm"')
					$("#logOutBtn").attr('onclick','logOut()')
					$("#profileBtn").click(function(){
						// open profile
					})
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
					$("#cartItem"+cartId).remove();
				}else{
					alert("Error occured")
				}
			}
		});
	});
	
	// Setting reduce quantity buttons disabled
	$(function() {
		if($(".cartQuantity"))
		{
			quantityItems = $(".cartQuantity");
			for(let element of quantityItems){
				if($(element).val()==1){
					$(element).prev().prop("disabled",true);
				}
			};
		}
	});

});

function emptyHeader(){
	$("#logOutBtn").text("Login")
	$("#cartCount").hide()
	$("#cartBtn").attr('onclick','location.href = "login.cfm?redirect=cart"')
	$("#profileBtn").attr('onclick','location.href = "login.cfm"')
	$("#logOutBtn").attr('onclick','location.href = "login.cfm"')
}

function logOut(){
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=logOut",
			success: function(result) {
				logOutResult=JSON.parse(result)
				if(logOutResult.success){
					emptyHeader();
					$("#productMessages").text("")
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

function addToCart(productId){
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=addToCart",
		data:{productId:productId},
		success: function(result) {
			addToCartResult=JSON.parse(result)
			if(addToCartResult.redirect){
				location.href="login.cfm?redirect=cart&productId="+productId
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
			newQuantity:newQuantity
		},
		success: function(result){
			changeQuantityResult=JSON.parse(result)
			if(changeQuantityResult.success){
				// setting input value
				quantityElement.val(newQuantity);
			}
		}
	});
}