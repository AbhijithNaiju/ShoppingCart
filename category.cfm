<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId") AND isNumeric(url.catId)>
    <cfset categoryProducts = application.userObject.getCategoryProducts(categoryId=url.catId)>
    <div class="m-2">
        <cfif categoryProducts.recordCount>
            <cfloop query="categoryProducts" group="subcategoryId">
                <cfquery  name = "subcategoryProducts" dbtype="query">
                    SELECT 
                        productId,
                        imageFileName,
                        productName,
                        brandName,
                        productPrice,
                        productTax
                    FROM
                        categoryProducts
                    WHERE
                        subCategoryId = #categoryProducts.subcategoryId#
                </cfquery>
                <cfif subcategoryProducts.recordCount>
                    <div class = "d-flex justify-content-between align-items-center mx-3">
                        <cfoutput>
                            <h3>
                                #categoryProducts.subcategoryName#
                            </h3>
                            <a 
                                href="./productListing.cfm?subcatId=#categoryProducts.subcategoryId#"
                                class = "subCategoryLink btn border" 
                            >
                                View all
                            </a>
                        </cfoutput>
                    </div>
                    <div class="productListingParent m-3">
                        <cfoutput query = "subcategoryProducts" maxRows=5>
                            <a 
                            href="product.cfm?productId=#subcategoryProducts.productId#" 
                            class="randomProducts p-3 d-flex flex-column align-items-center border"
                            >
                                <img src="./assets/productimages/#subcategoryProducts.imageFileName#"></img>
                                <div class="w-100 my-2">
                                    <h6>#subcategoryProducts.productName#</h6>
                                    <p>#subcategoryProducts.brandName#</p>
                                    <p class="mt-auto">Rs : #subcategoryProducts.productPrice + subcategoryProducts.productTax#</p>
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