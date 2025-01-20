<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "subcatId")>
    <cfif structKeyExists(url, "ascSort")>
        <cfset subcategoryProducts = application.userObject.getSubcategoryProducts(
                                                                                    subcategoryId=url.subcatId,
                                                                                    ascSort=url.ascSort
                                                                                )>
    <cfelseif structKeyExists(url, "descSort")>
        <cfset subcategoryProducts = application.userObject.getSubcategoryProducts(
                                                                                    subcategoryId=url.subcatId,
                                                                                    descSort=url.descSort
                                                                                )>
    <cfelse>
        <cfset subcategoryProducts = application.userObject.getSubcategoryProducts(
                                                                                    subcategoryId=url.subcatId
                                                                                )>
    </cfif>
    <cfoutput>
        <div class="m-2">
            <h3>
                #subcategoryProducts.subcategoryName#
            </h3>
            <form method="get">
                <input type="hidden" name="subcatId" value="#url.subcatId#">
                <button type="submit" name="ascSort" value="1" class="btn">Price : Low to high</button>
                <button type="submit" name="descSort" value="1" class="btn">Price : High to Low</button>
            </form>
            <cfif subcategoryProducts.recordCount>
                <div class="productListingParent m-3">
                    <cfloop query = "subcategoryProducts">
                        <a 
                        href="product.cfm?prodId=#subcategoryProducts.productId#" 
                        class="randomProducts p-3 d-flex flex-column align-items-center border"
                        >
                            <img src="./assets/productimages/#subcategoryProducts.imageFileName#"></img>
                            <div class="w-100 my-2">
                                <h6>#subcategoryProducts.productName#</h6>
                                <p>#subcategoryProducts.brandName#</p>
                                <p class="mt-auto">Rs : #subcategoryProducts.productPrice + subcategoryProducts.productTax#</p>
                            </div>
                        </a>
                    </cfloop>
                </div>
            <cfelse>
                <h6>No products found<h6>
            </cfif>
        </div>
    </cfoutput>
</cfif>
<cfinclude  template="userFooter.cfm">