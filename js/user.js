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
				$("#logoutBtn").text("Logout")
				$("#cartBtn").attr('onclick','location.href="cartPage.cfm"')
				$("#logoutBtn").attr('onclick','logout()')
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
	$("#logoutBtn").text("Login")
	$("#cartCount").hide()
	$("#cartBtn").attr('onclick','location.href = "login.cfm?redirect=cart"')
	$("#profileBtn").attr('onclick','location.href = "login.cfm"')
	$("#logoutBtn").attr('onclick','location.href = "login.cfm"')
}
function logout(){
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=logOut",
			success: function() {
				emptyHeader();
			}
		});
	}
}

function filterProduct(currentData){
	let minValue = $("#filterMin").val()
	let maxValue = $("#filterMax").val()
	if(minValue || maxValue){
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
				productsJson=JSON.parse(result)
				count=0;
				productsJson.forEach(productData => {
					count++;
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
		});
	}
}

function setFilter(range){
	$('#filterMin').val(range.min)
	$('#filterMax').val(range.max)
}

$('.filterInput').change(function(){
	$('[name=filterRadio]').prop('checked',false);
});

$(document).ready(function(){
	if(document.getElementById("productListingParent")){
		showLess();
	}
  });

function showMore(){
	showButton=document.getElementById("showButton");
	showButton.innerHTML="Show less"
	showButton.onclick=function() {showLess()};
	productElements=document.getElementById("productListingParent").children;
	for(i=0;i<productElements.length;i++){
		if(i>=8){
			productElements[i].classList.remove("displayNone");
		}
	}
}
function showLess() {
	showButton=document.getElementById("showButton");
	showButton.innerHTML="Show More"
	showButton.onclick=function() {showMore()};
	productElements=document.getElementById("productListingParent").children;
	for(i=0;i<productElements.length;i++){
		if(i>=8){
			productElements[i].classList.add("displayNone");
		}
	}
}	