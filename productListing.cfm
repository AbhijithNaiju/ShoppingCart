<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "searchValue") OR ( structKeyExists(url, "subcatId") AND isNumeric(url.subcatId))>
    <cfset arrayProductId = arrayNew(1)>
    <cfif structKeyExists(url, "sortOrder") AND structKeyExists(url, "searchvalue")>
        <cfset variables.productList = application.userObject.getProductList(
            searchValue=url.searchValue,
            sortOrder=url.sortOrder
        )>
    <cfelseif structKeyExists(url, "searchvalue")>
        <cfset variables.productList = application.userObject.getProductList(
            searchValue=url.searchValue
        )>
        
    <cfelseif structKeyExists(url, "sortOrder") AND structKeyExists(url, "subcatId")>
        <cfset variables.productList = application.userObject.getProductList(
            sortOrder=url.sortOrder,
            subcategoryId=url.subcatId
        )>
    <cfelseif structKeyExists(url, "subcatId") >
        <cfset variables.productList = application.userObject.getProductList(
            subcategoryId=url.subcatId
        )>
    </cfif>
    <cfif structKeyExists(url, "subcatId")>
        <cfset variables.subcatId = url.subcatId>
        <cfset variables.searchValue = ''>
    <cfelseif structKeyExists(url, "searchValue")>
        <cfset variables.searchValue = url.searchValue>
        <cfset variables.subcatId = 0>
    </cfif>
    <cfif structKeyExists(url, "sortOrder")>
        <cfset variables.sortOrder = url.sortOrder>
    <cfelse>
        <cfset variables.sortOrder = 0>
    </cfif>
    <cfoutput>
        <div class="m-2">
            <h3>
                <cfif structKeyExists(url, "searchvalue")>
                    Search result for #url.searchValue#
                <cfelseif structKeyExists(url, "subcatId") AND arrayLen(variables.productList)>
                    #variables.productList[1].subcategoryName#
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
                    <button 
                        class="btn btn-secondary dropdown-toggle" 
                        type="button" 
                        data-bs-toggle="dropdown" 
                        data-bs-auto-close="outside" 
                        aria-expanded="false"
                    >
                        Filter
                    </button>
                    <ul class="dropdown-menu p-2">
                        <li class = "form-control">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter1" 
                                onclick='setFilter({min:0,max:1000})'
                            >
                            <label for="filter1">0-1000</label>
                        </li>
                        <li class = "form-control">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter2" 
                                onclick='setFilter({min:1000,max:10000})'
                            >
                            <label for="filter2">1000-10000</label>
                        </li>
                        <li class = "form-control">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter3" 
                                onclick='setFilter({min:10000,max:15000})'
                            >
                            <label for="filter3">10000-15000</label>
                        </li>
                        <li class="d-flex flex-column align-items-center my-1">
                            <input type="number" id="filterMin" placeholder="Min" class="form-control filterInput">
                            TO
                            <input type="number" id="filterMax" placeholder="Max" class="form-control filterInput">
                        </li>
                        <li>
                            <button 
                                class = "btn w-100 border my-1" 
                                onclick="clearFilter()"
                            >
                                Clear
                            </button>
                            <button 
                                class="btn w-100 border my-1"
                                onclick="filterProducts({
                                    subcategoryId:#variables.subcatId#,
                                    searchValue:'#variables.searchValue#',
                                    sortOrder:'#variables.sortOrder#'
                                })"
                                aria-expanded="false"
                            >
                                Submit
                            </button>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="text-center" id="listingMessage"></div>
            <cfif arrayLen(variables.productList)>
                <div class="productListingParent m-3" id="productListingParent">
                    <cfloop array = "#variables.productList#" item="productDetails" index="productIndex">
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
                        <cfset arrayAppend(arrayProductId, productDetails.productId)>
                        <cfif productIndex GTE 10>
                            <cfbreak>
                        </cfif>
                    </cfloop>
                </div>
                <cfif arrayLen(variables.productList) GT 10>
                    <div class="d-flex justify-content-center">
                        <button 
                            class="btn border my-1"
                            id="showMoreBtn"
                            onclick="showMore({
                                subcategoryId:#variables.subcatId#,
                                searchValue:'#variables.searchValue#',
                                sortOrder:'#variables.sortOrder#',
                                excludedIdList:'#arraytolist(arrayProductId)#'
                            })" 
                            aria-expanded="false"
                        >
                            Show more
                        </button>
                    </div>
                </cfif>
            <cfelse>
                <div class = "text-center" >No products found<div>
            </cfif>
        </div>
    </cfoutput>
<cfelse>
    <cflocation  url="index.cfm">
</cfif>
<cfinclude  template="userFooter.cfm">