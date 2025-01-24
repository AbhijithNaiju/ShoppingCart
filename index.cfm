<cfinclude  template="./userHeader.cfm">
<cfset randomProducts = application.userObject.getCategoryProducts()>
<cfoutput>
    <div class="">
        <h3>
            Random Products
        </h3>
        <div class="productListingParent m-3">
            <cfloop query = "randomProducts">
                <a 
                    href="product.cfm?productId=#randomProducts.productId#" 
                    class="randomProducts p-3 d-flex flex-column align-items-center border"
                >
                    <img src="./assets/productimages/#randomProducts.imageFileName#"></img>
                    <div class="w-100 my-2">
                        <h6>#randomProducts.productName#</h6>
                        <p>#randomProducts.brandName#</p>
                        <p class="mt-auto">Rs : #randomProducts.productPrice + randomProducts.productTax#</p>
                    </div>
                </a>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">