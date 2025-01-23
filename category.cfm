<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId") AND isNumeric(url.catId)>
    <cfset categoryProducts = application.userObject.getCategoryProducts(categoryId=url.catId)>
    <cfset subcategories = application.userObject.getAllSubcategories(categoryId=url.catId)>
    <div class="m-2">
        <cfloop query="subcategories">
            <cfquery  name = "subcategoryProducts" dbtype="query">
                SELECT 
                    *
                FROM
                    categoryProducts
                WHERE
                    subCategoryId = #subcategories.subcategoryId#
            </cfquery>
            <cfif subcategoryProducts.recordCount>
                <h3>
                    <cfoutput>
                        <a href="./productListing.cfm?subcatId=#subcategories.subcategoryId#">
                            #subcategories.subcategoryName#
                        </a>
                    </cfoutput>
                </h3>
                <div class="productListingParent m-3">
                    <cfoutput query = "subcategoryProducts" maxRows=4>
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
    </div>
</cfif>
<cfinclude  template="userFooter.cfm">