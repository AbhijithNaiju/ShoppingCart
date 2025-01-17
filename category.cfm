<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId")>
    <cfoutput>
        <cfset categoryProducts = application.userObject.getCategoryProducts()>
        <div class="h-50 border-dark">
            <h1>
                Random Products
            </h1>
            <div class="d-flex flex-wrap m-2 justify-content-around">
                <cfloop query = "categoryProducts">
                    <a 
                        href="product.cfm?proId=#categoryProducts.productId#" 
                        class="randomProducts border border-dark m-2 p-2 d-flex flex-column align-items-center"
                    >
                        <img src="./assets/productimages/#categoryProducts.imageFileName#"></img>
                        <h6>#categoryProducts.productName#</h6>
                        <p>#categoryProducts.brandName#</p>
                    </a>
                </cfloop>
            </div>
            </div>
    </cfoutput>
</cfif>
<cfinclude  template="userFooter.cfm">