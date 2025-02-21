<cfinclude  template="userHeader.cfm">
<cfif structKeyExists(url, "searchValue") OR ( structKeyExists(url, "subcatId") AND isNumeric(url.subcatId))>
    <cfset variables.arrayProductId = arrayNew(1)>
    <cfif structKeyExists(url, "sortOrder") AND structKeyExists(url, "searchvalue")>
        <cfset variables.productList = application.userObject.getProductList(
            searchValue=url.searchValue,
            sortOrder=url.sortOrder,
            limit=10,
            count=true
        )>
    <cfelseif structKeyExists(url, "searchvalue")>
        <cfset variables.productList = application.userObject.getProductList(
            searchValue=url.searchValue,
            limit=10,
            count=true
        )>
        
    <cfelseif structKeyExists(url, "sortOrder") AND structKeyExists(url, "subcatId")>
        <cfset variables.productList = application.userObject.getProductList(
            sortOrder=url.sortOrder,
            subcategoryId=url.subcatId,
            limit=10,
            count=true
        )>
    <cfelseif structKeyExists(url, "subcatId") >
        <cfset variables.productList = application.userObject.getProductList(
            subcategoryId=url.subcatId,
            limit=10,
            count=true
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
        <div class="m-3">
            <h3>
                <cfif structKeyExists(url, "searchvalue")>
                    Search result for #url.searchValue#
                <cfelseif structKeyExists(url, "subcatId") AND arrayLen(variables.productList.resultArray)>
                    #variables.productList.resultArray[1].subcategoryName#
                </cfif>
            </h3>
            <div class="d-flex justify-content-between mx-2">
                <form method="get">
                    <cfif structKeyExists(url, "searchvalue")>
                        <input type="hidden" name="searchValue" value="#url.searchValue#">
                    <cfelseif structKeyExists(url, "subcatId")>
                        <input type="hidden" name="subcatId" value="#url.subcatId#">
                    </cfif>
                    <button 
                        type="submit" 
                        name="sortOrder" 
                        value="asc" 
                        class="btn"
                        <cfif variables.sortOrder EQ "asc">
                            disabled
                        </cfif>
                    >
                        Price : Low to high
                    </button>
                    <button 
                        type="submit" 
                        name="sortOrder" 
                        value="desc" 
                        class="btn"
                        <cfif variables.sortOrder EQ "desc">
                            disabled
                        </cfif>
                    >
                        Price : High to low
                    </button>
                </form>
                <div class="dropdown">
                    <button 
                        class="btn btn-secondary dropdown-toggle" 
                        type="button" 
                        data-bs-toggle="dropdown" 
                        data-bs-auto-close="outside" 
                        aria-expanded="false"
                    >
                        Price Filter
                    </button>
                    <ul class="dropdown-menu p-2">
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter1" 
                                onclick='setFilter({min:0,max:1000})'
                            >
                            <label for="filter1">0 - 1000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter2" 
                                onclick='setFilter({min:1000,max:10000})'
                            >
                            <label for="filter2">1000 - 10000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                name="filterRadio" 
                                id="filter3" 
                                onclick='setFilter({min:10000,max:15000})'
                            >
                            <label for="filter3">10000 - 15000</label>
                        </li>
                        <li class="d-flex flex-column align-items-center my-1 ">
                            <input 
                                type="number" 
                                id="filterMin" 
                                placeholder="Min" 
                                class="form-control filterInput"
                            >
                            TO
                            <input 
                                type="number" 
                                id="filterMax" 
                                placeholder="Max" 
                                class="form-control filterInput"
                            >
                        </li>
                        <li><hr class="dropdown-divider"></li>
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
                        <li class = " text-center">
                            <small class = "text-danger" id="filterError"></small>
                        </li>
                    </ul>
                </div>
            </div>
            <cfif 
                arrayLen(variables.productList.resultArray) 
                AND 
                structKeyExists(variables.productList.resultArray[1],"productId"
            )>
                <div class="productListingParent my-3 mx-5" id="productListingParent">
                    <cfloop array = "#variables.productList.resultArray#" item="variables.productDetails">
                        <a 
                            href="product.cfm?productId=#variables.productDetails.productId#" 
                            class="randomProducts d-flex flex-column justify-content-between align-items-center border shadow-sm"
                        >
                            <div class="card-img-top randomProductImage d-flex align-items-center justify-content-center">
                                <img src="./assets/productimages/#variables.productDetails.imageFileName#"></img>
                            </div>
                            <div class="w-100 d-flex flex-column randomProductsDetails">
                                <h6 class="card-title p-2">#variables.productDetails.productName#</h6>
                                <span class = "productBrand text-secondary px-2">#variables.productDetails.brandName#</span>
                                <span class="mt-auto px-2 randomProductPrice">
                                    Rs : #variables.productDetails.productPrice + variables.productDetails.productTax#
                                </span>
                            </div>
                        </a>
                        <cfset arrayAppend(variables.arrayProductId, variables.productDetails.productId)>
                    </cfloop>
                </div>
                <cfif variables.productList.productCount GT 10>
                    <div class="d-flex justify-content-center">
                        <button 
                            class="btn border my-1"
                            id="showMoreBtn"
                            value="#arraytolist(variables.arrayProductId)#"
                            onclick="showMore({
                                subcategoryId:#variables.subcatId#,
                                searchValue:'#variables.searchValue#',
                                sortOrder:'#variables.sortOrder#'
                            })" 
                            aria-expanded="false"
                        >
                            Show more
                        </button>
                    </div>
                    <input 
                        type="hidden" 
                        value="#variables.productList.productCount#"
                        id="totalProductCount"
                    >
                </cfif>
                <div class="text-center" id="listingMessage"></div>
            <cfelse>
                <div class = "text-center" id = "listingMessage">No products found<div>
            </cfif>
        </div>
    </cfoutput>
<cfelse>
    <cflocation  url="index.cfm">
</cfif>
<cfinclude  template="userFooter.cfm">