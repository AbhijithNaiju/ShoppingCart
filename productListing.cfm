<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "searchValue") OR ( structKeyExists(url, "subcatId") AND isNumeric(url.subcatId))>

    <cfif structKeyExists(url, "sortOrder") AND structKeyExists(url, "searchvalue")>
        <cfset productList = application.userObject.getProductList(
                                                                            searchValue=url.searchValue,
                                                                            sortOrder=url.sortOrder
                                                                        )>
    <cfelseif structKeyExists(url, "searchvalue")>
        <cfset productList = application.userObject.getProductList(
                                                                            searchValue=url.searchValue
                                                                        )>
    <cfelseif structKeyExists(url, "sortOrder") AND structKeyExists(url, "subcatId")>
        <cfset productList = application.userObject.getProductList(
                                                                            sortOrder=url.sortOrder,
                                                                            subcategoryId=url.subcatId
                                                                        )>
    <cfelseif structKeyExists(url, "subcatId") >
        <cfset productList = application.userObject.getProductList(
                                                                            subcategoryId=url.subcatId
                                                                        )>
    </cfif>
    <cfoutput>
        <div class="m-2">
            <h3>
                <cfif structKeyExists(url, "searchvalue")>
                    Search result for #url.searchValue#
                <cfelseif structKeyExists(url, "subcatId") AND arrayLen(productList)>
                    #productList[1].subcategoryName#
                </cfif>
            </h3>
            <div class="d-flex justify-content-between mx-2">
                <form method="get">
                    <cfif structKeyExists(url, "searchvalue")>
                        <input type="hidden" name="searchValue" value="#url.searchValue#">
                    <cfelseif structKeyExists(url, "subcatId")>
                        <input type="hidden" name="subcatId" value="#url.subcatId#">
                    </cfif>
                    <button type="submit" name="sortOrder" value="asc" class="btn">Price : Low to high</button>
                    <button type="submit" name="sortOrder" value="desc" class="btn">Price : High to Low</button>
                </form>
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        Filter
                    </button>
                    <ul class="dropdown-menu p-2">
                        <li>
                            <input type="radio" name="filterRadio" onclick='setFilter({min:0,max:1000})'>
                            0-1000
                        </li>
                        <li>
                            <input type="radio" name="filterRadio" onclick='setFilter({min:1000,max:10000})'>
                            1000-10000
                        </li>
                        <li>
                            <input type="radio" name="filterRadio" onclick='setFilter({min:10000,max:15000})'>
                            10000-15000
                        </li>
                        <li class="d-flex flex-column align-items-center">
                            <input type="number" id="filterMin" placeholder="Min" class="form-control filterInput">
                            TO
                            <input type="number" id="filterMax" placeholder="Max" class="form-control filterInput">
                        </li>
                        <li>
                            <button 
                                class="btn w-100 border my-1"
                                onclick="filterProduct({
                                                        <cfif structKeyexists(url,"subcatId")>
                                                            subcategoryId:'#url.subcatId#',
                                                        <cfelseif structKeyexists(url,"sortOrder")>
                                                            searchValue:'#url.searchValue#',
                                                        </cfif>
                                                        <cfif structKeyexists(url,"sortOrder")>
                                                            sortOrder:'#url.sortOrder#'
                                                        </cfif>
                                                    })" 
                            >
                                Submit
                            </button>
                        </li>
                    </ul>
                </div>
            </div>
            <cfif arrayLen(productList)>
                <div class="productListingParent m-3" id="productListingParent">
                    <cfloop array = "#productList#" item="productDetails" index="productIndex">
                        <a 
                        href="product.cfm?productId=#productDetails.productId#" 
                        class="randomProducts p-3 align-items-center border"
                        >
                            <img src="./assets/productimages/#productDetails.imageFileName#"></img>
                            <div class="w-100 my-2">
                                <h6>#productDetails.productName#</h6>
                                <p>#productDetails.brandName#</p>
                                <p class="mt-auto">Rs : #productDetails.productPrice + productDetails.productTax#</p>
                            </div>
                        </a>
                    </cfloop>
                </div>
                <cfif arrayLen(productList) GT 8>
                    <div class="d-flex justify-content-center">
                        <button class="btn border" id="showButton" onclick="showMore()">Show more</button>
                    </div>
                </cfif>
            <cfelse>
                <h6>No products found<h6>
            </cfif>
        </div>
    </cfoutput>
<cfelse>
    <cflocation  url="index.cfm">
</cfif>
<cfinclude  template="userFooter.cfm">