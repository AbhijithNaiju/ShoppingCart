<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "catId") AND isValid("integer",url.catId)>
    <cfset variables.productCount = 0>
    <cfset variables.subcategoryList = application.productObject.getSubcategories(categoryId=url.catId)>
    <div class="container-fluid h-100">
        <cfoutput>
            <div class = "d-flex border-bottom border-secondary my-2">
                    <h2>
                        #variables.subcategoryList.categoryName#
                    </h2>
            </div>
            <cfif variables.subcategoryList.recordCount>
                <cfloop query="variables.subcategoryList">
                    <cfset variables.subcategoryProductList =  application.productObject.getProductList(
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
                        <div class="productListingParent my-3 mx-5">
                            <cfloop array="#variables.subcategoryProductList.resultArray#" item="variables.subcategoryProduct">
                                <cfif structKeyExists(variables.subcategoryProduct,"productId")>
                                    <a 
                                        href="product.cfm?productId=#variables.subcategoryProduct.productId#" 
                                        class="border randomProducts d-flex flex-column justify-content-between align-items-center shadow-sm"
                                    >
                                        <div class="card-img-top randomProductImage d-flex align-items-center justify-content-center">
                                            <img src="./assets/productimages/#variables.subcategoryProduct.imageFileName#"></img>
                                        </div>
                                        <div class="w-100 d-flex flex-column randomProductsDetails">
                                            <h6 class="card-title p-2">#variables.subcategoryProduct.productName#</h6>
                                            <span class = "productBrand text-secondary px-2">#variables.subcategoryProduct.brandName#</span>
                                            <span class="mt-auto px-2 randomProductPrice">
                                                Rs :
                                                #numberFormat(variables.subcategoryProduct.productPrice + variables.subcategoryProduct.productTax,'__.00')#

                                            </span>
                                        </div>
                                    </a>
                                </cfif>
                                <cfset variables.productCount += 1>
                            </cfloop>
                        </div>
                    </cfif>
                </cfloop>
            <cfelse>
                <cflocation  url="./missingPage.cfm" addtoken="false">
            </cfif>
            <cfif variables.productCount EQ 0>
                <div class = "text-center" >No products found</div>
            </cfif>
        </cfoutput>
    </div>
</cfif>
<cfinclude  template="userFooter.cfm">