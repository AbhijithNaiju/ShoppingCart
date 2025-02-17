<cfinclude  template="./userHeader.cfm">
<cfset variables.productList = application.userObject.getProductList(limit=10)>
<cfoutput>
    <div class="">
        <h3>
            Random Products
        </h3>
        <div class="productListingParent m-3">
            <cfloop array = "#variables.productList.resultArray#" item="variables.productItem">
                <a 
                    href="product.cfm?productId=#variables.productItem.productId#" 
                    class="randomProducts p-3 d-flex flex-column align-items-center border"
                >
                    <img src="./assets/productimages/#productItem.imageFileName#"></img>
                    <div class="w-100 my-2">
                        <h6>#variables.productItem.productName#</h6>
                        <p>#variables.productItem.brandName#</p>
                        <p class="mt-auto">Rs : #variables.productItem.productPrice + variables.productItem.productTax#</p>
                    </div>
                </a>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">