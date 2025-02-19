<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId") AND isNumeric(url.catId)>
    <cfset variables.productCount = 0>
    <cfset variables.subcategoryList = application.userObject.getSubcategories(categoryId=url.catId)>
    <div class="container-fluid h-100">
        <cfoutput>
            <div class = "d-flex border-bottom border-secondary my-2">
                    <h2>
                        #variables.subcategoryList.categoryName#
                    </h2>
            </div>
            <cfif variables.subcategoryList.recordCount>
                <cfloop query="variables.subcategoryList">
                    <cfset variables.subcategoryProductList =  application.userObject.getProductList(
                        subcategoryId=variables.subcategoryList.subcategoryId,
                        limit=5
                    )>
                    <cfif arraylen(variables.subcategoryProductList.resultArray)>
                        <div class = "d-flex justify-content-between align-items-center mx-3">
                            <h3>
                                #variables.subcategoryList.subcategoryName#
                            </h3>
                            <a
                                href="./productListing.cfm?subcatId=#variables.subcategoryList.subcategoryId#"
                                class = "subCategoryLink btn border" 
                            >
                                View all
                            </a>
                        </div>
                        <div class="productListingParent m-3">
                            <cfloop array="#variables.subcategoryProductList.resultArray#" item="variables.subcategoryProduct">
                                <cfif structKeyExists(variables.subcategoryProduct,"productId")>
                                    <a 
                                    href="product.cfm?productId=#variables.subcategoryProduct.productId#" 
                                    class="randomProducts p-3 d-flex flex-column align-items-center border"
                                    >
                                        <img src="./assets/productimages/#variables.subcategoryProduct.imageFileName#"></img>
                                        <div class="w-100 my-2">
                                            <h6>#variables.subcategoryProduct.productName#</h6>
                                            <p class = "productBrand text-secondary">#variables.subcategoryProduct.brandName#</p>
                                            <p class="mt-auto">Rs : #variables.subcategoryProduct.productPrice + variables.subcategoryProduct.productTax#</p>
                                        </div>
                                    </a>
                                </cfif>
                                <cfset variables.productCount += 1>
                            </cfloop>
                        </div>
                    </cfif>
                </cfloop>
            <cfelse>
                <div class = "text-center" >No products found</div>
            </cfif>
            <cfif variables.productCount EQ 0>
                <div class = "text-center" >No products found</div>
            </cfif>
        </cfoutput>
    </div>
</cfif>
<cfinclude  template="userFooter.cfm">