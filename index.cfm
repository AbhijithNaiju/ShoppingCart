<cfinclude  template="./userHeader.cfm">
<cfset variables.randomProducts = application.userObject.getRandomProducts()>
<cfoutput>
    <div class="">
        <h3>
            Random Products
        </h3>
        <div class="productListingParent m-3">
            <cfloop query = "variables.randomProducts">
                <a 
                    href="product.cfm?productId=#variables.randomProducts.productId#" 
                    class="randomProducts p-3 d-flex flex-column align-items-center border"
                >
                    <img src="./assets/productimages/#randomProducts.imageFileName#"></img>
                    <div class="w-100 my-2">
                        <h6>#variables.randomProducts.productName#</h6>
                        <p>#variables.randomProducts.brandName#</p>
                        <p class="mt-auto">Rs : #variables.randomProducts.productPrice + variables.randomProducts.productTax#</p>
                    </div>
                </a>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">