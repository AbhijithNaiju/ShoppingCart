function logout(){
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=logOut",
			success: function() {
				location.reload();
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
				productsJson.forEach(productData => {
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