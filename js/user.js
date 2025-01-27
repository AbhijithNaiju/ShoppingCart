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
			}
			else{
				emptyHeader();
			}
		}
	});
}

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

$('.filterInput').click(function(){
	$('[name=filterRadio]').prop('checked',false);
});

function clearFilter(){
	setFilter({min:'',max:''});
	$('[name=filterRadio]').prop('checked',false);
}

function filterProducts(currentData){
	let minValue = $("#filterMin").val()
	let maxValue = $("#filterMax").val()
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=getProductList",
			data:{
					minPrice:minValue,
					maxPrice:maxValue,
					subcategoryId:currentData.subcategoryId,
					searchValue:currentData.searchValue,
					sortOrder:currentData.sortOrder
				},
			success: function(result) {
				$('#productListingParent').empty();
				productList=JSON.parse(result)
				listProducts(productList)
				$("#showMoreBtn").css("display","none");
				if(productList.length){
					$('#listingMessage').text("");
				}
				else{
					$('#listingMessage').text("No products Found");
				}
			}
		});
	$(".dropdown-toggle").dropdown('toggle');
}

function listProducts(productList)
{
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
		$("#productListingParent").append(productBody)
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
			}
			else{
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
	let minValue = $("#filterMin").val()
	let maxValue = $("#filterMax").val()
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=getProductList",
			data:{
					minPrice:minValue,
					maxPrice:maxValue,
					subcategoryId:currentData.subcategoryId,
					searchValue:currentData.searchValue,
					sortOrder:currentData.sortOrder,
					excludedIdList:currentData.excludedIdList
				},
			success: function(result) {
				listProducts(JSON.parse(result))
				$("#showMoreBtn").css("display","none")
			}
		});
}