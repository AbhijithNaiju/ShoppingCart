var offset = 10;
$(document).ready(function(){
	// Used to unselect radio when custom min max are used
	$('.filterInput').click(function(){
		$('[name=filterRadio]').prop('checked',false);
	});

	$(".sortProductsBtn").click(function(){
		$("#sortOrder").val(this.value)
	});
});

function setFilter(range){
	$('#filterMin').val(range.min);
	$('#filterMax').val(range.max);
}

function clearFilter(){
	$('#filterMin').val('');
	$('#filterMax').val('');
	// $('#filterMin').attr("value",'')
	// $('#filterMax').attr("value",'')
	$('[name=filterRadio]').prop('checked',false);
}

function filterProducts(){
	let minValue = $("#filterMin").val();
	let maxValue = $("#filterMax").val();
	if(minValue < 0 || maxValue < 0){
		$("#filterError").text("Please enter a positive number");
		event.preventDefault();
	}else{
		$("#filterError").text("");
		$("#filterMin").attr("value",minValue);
		$("#filterMax").attr("value",maxValue);
	}
}

function showMore(subcategoryId,searchValue,sortOrder,minPrice,maxPrice)
{
	let totalProductCount = $("#showMoreBtn");
	const productData = new Object();
	if(subcategoryId){
		productData.subcategoryId = subcategoryId;
	}else if(searchValue != ''){
		productData.searchValue = searchValue;
	}
	productData.minPrice = minPrice;
	productData.maxPrice = maxPrice;
	productData.sortOrder = sortOrder;
	productData.limit = 5;
	productData.offset = offset;
	
	$.ajax({
		type:"POST",
		url:"components/product.cfc?method=getProductList",
		data:productData,
		success: function(result) {
			resultJson=JSON.parse(result);
			if(resultJson.success){
				if(resultJson.resultArray.length){
					offset+=resultJson.resultArray.length;
					$('#listingMessage').text("");
					resultJson.resultArray.forEach(productData => {
						let productBody = `
							<a 
								href="product.cfm?productId=${encodeURIComponent(productData.productId)}" 
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
						$("#productListingParent").append(productBody);
					});

					if(offset >= resultJson.resultArray[0].totalCount){
						totalProductCount.hide();
					}
				}else{
					totalProductCount.hide();
					Swal.fire({
							position: "top",
							toast: true,
							icon: "error",
							title: "No more products found",
							showConfirmButton: false,
							timer: 1500
						});
					}
			}else{
				Swal.fire({
					position: "top",
					toast: true,
					icon: "error",
					title: "Error occured while loading products",
					showConfirmButton: false,
					timer: 1500
				});
			}
		},error: function(){
			alert("Error occured");
		}
	});
}