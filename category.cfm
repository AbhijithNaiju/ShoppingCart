<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId") AND isNumeric(url.catId)>
    <cfset variables.categoryProducts = application.userObject.getCategoryProducts(categoryId=url.catId)>
    <div class="m-2">
        <cfif variables.categoryProducts.recordCount>
            <cfloop query="variables.categoryProducts" group="subcategoryId">
                <cfquery  name = "variables.subcategoryProducts" dbtype="query">
                    SELECT 
                        productId,
                        imageFileName,
                        productName,
                        brandName,
                        productPrice,
                        productTax
                    FROM
                        variables.categoryProducts
                    WHERE
                        subCategoryId = #variables.categoryProducts.subcategoryId#
                </cfquery>
                <cfif variables.subcategoryProducts.recordCount>
                    <div class = "d-flex justify-content-between align-items-center mx-3">
                        <cfoutput>
                            <h3>
                                #variables.categoryProducts.subcategoryName#
                            </h3>
                            <a 
                                href="./productListing.cfm?subcatId=#variables.categoryProducts.subcategoryId#"
                                class = "subCategoryLink btn border" 
                            >
                                View all
                            </a>
                        </cfoutput>
                    </div>
                    <div class="productListingParent m-3">
                        <cfoutput query = "variables.subcategoryProducts" maxRows=5>
                            <a 
                            href="product.cfm?productId=#variables.subcategoryProducts.productId#" 
                            class="randomProducts p-3 d-flex flex-column align-items-center border"
                            >
                                <img src="./assets/productimages/#variables.subcategoryProducts.imageFileName#"></img>
                                <div class="w-100 my-2">
                                    <h6>#variables.subcategoryProducts.productName#</h6>
                                    <p>#variables.subcategoryProducts.brandName#</p>
                                    <p class="mt-auto">Rs : #variables.subcategoryProducts.productPrice + variables.subcategoryProducts.productTax#</p>
                                </div>
                            </a>
                        </cfoutput>
                    </div>
                </cfif>
            </cfloop>
        <cfelse>
            <div class = "text-center" >No products found</div>
        </cfif>
    </div>
</cfif>
<cfinclude  template="userFooter.cfm">