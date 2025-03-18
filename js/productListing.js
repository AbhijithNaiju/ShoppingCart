$(document).ready(function(){
	// Used to unselect radio when custom min max are used
	$('.filterInput').click(function(){
		$('[name=filterRadio]').prop('checked',false);
	});

	$(".sortProductsBtn").click(function(){
		$("#sortOrder").val(this.value)
	});

	$("#showMoreBtn").click(function(){
		const subcategoryId = $("#subcategoryId").val();
		const searchValue = $("#searchValue").val();
		const minPrice = $("#filterMin").val();
		const maxPrice = $("#filterMax").val();
		const sortOrder = $("#sortOrder").val();
		const showMoreBtn = $("#showMoreBtn");
		let offset = parseInt(showMoreBtn.val());
		const productData = new Object();

		productData.subcategoryId = (subcategoryId)?subcategoryId:'';
		productData.searchValue = (searchValue)?searchValue:'';
		productData.minPrice = (minPrice.length)?minPrice:-1;
		productData.maxPrice = (maxPrice.length)?maxPrice:-1;
		productData.sortOrder = (sortOrder)?sortOrder:"name";
		productData.limit = 5;
		productData.offset = offset;
		productData.method="getProductListRemote";
		
		$.ajax({
			type:"POST",
			url:"components/product.cfc",
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
							showMoreBtn.val(offset)
						});

						if(offset >= resultJson.resultArray[0].totalCount){
							showMoreBtn.hide();
						}
					}else{
						showMoreBtn.hide();
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
	});

	$("#clearFilter").click(function(){
		$('#filterMin').val('');
		$('#filterMax').val('');
		$('[name=filterRadio]').prop('checked',false);
	});
	$("#filterForm").submit(function(){
		let minValue = $("#filterMin").val();
		let maxValue = $("#filterMax").val();
		if(minValue < 0 || maxValue < 0){
			$("#filterError").text("Please enter a positive price");
			if(minValue<0){
				$("#filterMin").focus();
			}
			if(maxValue<0){
				$("#filterMax").focus();
			}
			return false;
		}else{
			$("#filterError").text("");
			$("#filterMin").attr("value",minValue);
			$("#filterMax").attr("value",maxValue);
		}
	});
});

function setFilter(min,max){
	$('#filterMin').val(min);
	$('#filterMax').val(max);
}

const myDropdown = document.getElementById('minMaxDropdown')
myDropdown.addEventListener('hide.bs.dropdown', event => {
	$("#filterMin").val('');
	$("#filterMax").val('');
})