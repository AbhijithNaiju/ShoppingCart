<cfinclude  template="./userHeader.cfm">
<cfset variables.productList = application.userObject.getProductList(limit=10)>
<cfoutput>
    <div class="">
        <div class="productListingParent my-3 mx-5">
            <cfloop array = "#variables.productList.resultArray#" item="variables.productItem">
                <a 
                    href="product.cfm?productId=#variables.productItem.productId#" 
                    class="border randomProducts d-flex flex-column justify-content-between align-items-center shadow-sm"
                >
                    <div class="card-img-top randomProductImage d-flex align-items-center justify-content-center">
                        <img src="./assets/productimages/#productItem.imageFileName#" >
                    </div>
                    <div class="w-100 d-flex flex-column">
                        <h6 class="card-title p-2">#variables.productItem.productName#</h6>
                        <span class = "productBrand text-secondary px-2">#variables.productItem.brandName#</span>
                        <span class="mt-auto px-2">Rs : #variables.productItem.productPrice + variables.productItem.productTax#</span>
                    </div>
                </a>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">