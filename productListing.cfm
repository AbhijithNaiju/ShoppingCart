<cfinclude template="userHeader.cfm">
<cfparam name="url.sortOrder" default="0">
<cfparam name="url.searchValue" default="">
<cfparam name="url.subcatId" default="0">
<cfparam name="url.minPrice" default="-1">
<cfparam name="url.maxPrice" default="-1">
<cfif url.minPrice EQ "">
    <cfset url.minPrice = -1>
</cfif>
<cfif url.maxPrice EQ "">
    <cfset url.maxPrice = -1>
</cfif>
<cfif url.searchvalue NEQ "" OR (url.subcatId NEQ 0 AND isNumeric(url.subcatId))>
    <cfset variables.arrayProductId = arrayNew(1)>
    <cfif url.searchvalue NEQ "">
        <cfset variables.productList = application.userObject.getProductList(
            searchValue=url.searchValue,
            sortOrder=url.sortOrder,
            limit=10,
            count=true,
            minPrice=url.minPrice,
            maxPrice=url.maxPrice
        )>
    <cfelse>
        <cfset variables.productList = application.userObject.getProductList(
            sortOrder=url.sortOrder,
            subcategoryId=url.subcatId,
            limit=10,
            count=true,
            minPrice=url.minPrice,
            maxPrice=url.maxPrice
        )>
    </cfif>
    <cfoutput>
        <div class="m-3">
            <h3>
                <cfif url.searchValue NEQ "">
                    Search result for #url.searchValue#
                <cfelseif url.subcatId NEQ 0 AND arrayLen(variables.productList.resultArray)>
                    #variables.productList.resultArray[1].subcategoryName#
                </cfif>
            </h3>
            <form method="get" class="d-flex justify-content-between mx-2">
                <div class="d-flex justify-content-between mx-2">
                    <cfif LEN(url.searchValue)>
                        <input type="hidden" name="searchValue" value="#url.searchValue#">
                    <cfelseif structKeyExists(url, "subcatId")>
                        <input type="hidden" name="subcatId" value="#url.subcatId#">
                    </cfif>
                    <input 
                        type="hidden" 
                        name="sortOrder" 
                        id="sortOrder" 
                        <cfif url.sortOrder EQ "asc">
                            value="asc"
                        <cfelseif url.sortOrder EQ "desc">
                            value="desc"
                        </cfif>
                    >
                    <button 
                        type="submit" 
                        value="asc" 
                        class="btn me-1 sortProductsBtn"
                        <cfif url.sortOrder EQ "asc">
                            disabled
                        </cfif>
                    >
                        Price : Low to high
                    </button>
                    <button 
                        type="submit" 
                        value="desc" 
                        class="btn sortProductsBtn"
                        <cfif url.sortOrder EQ "desc">
                            disabled
                        </cfif>
                    >
                        Price : High to low
                    </button>
                </div>
                <div class="dropdown" id="dropdownForm">
                    <button 
                        class="btn btn-secondary dropdown-toggle"
                        id="filterDropdown"
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
                                class="filterRadio" 
                                id="filter1" 
                                onclick='setFilter({min:0,max:1000})'
                            >
                            <label for="filter1">0 - 1000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                class="filterRadio" 
                                id="filter2" 
                                onclick='setFilter({min:1000,max:10000})'
                            >
                            <label for="filter2">1000 - 10000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                class="filterRadio" 
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
                                name="minPrice"
                                <cfif LEN(url.minPrice) AND url.minPrice GTE 0>
                                    value="#url.minPrice#"
                                </cfif>
                            >
                            TO
                            <input 
                                type="number" 
                                id="filterMax" 
                                placeholder="Max" 
                                class="form-control filterInput"
                                name="maxPrice"
                                <cfif LEN(url.maxPrice) AND url.maxPrice GTE 0>
                                    value="#url.maxPrice#"
                                </cfif>
                            >
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <button 
                                class = "btn w-100 border my-1" 
                                type = "button"
                                onclick="clearFilter()"
                            >
                                Clear
                            </button>
                            <button 
                                class="btn w-100 border my-1"
                                type = "submit"
                                onclick="filterProducts()"
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
            </form>
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
                            onclick="showMore(
                                #url.subcatId#,
                                '#url.searchValue#',
                                '#url.sortOrder#',
                                #url.minPrice#,
                                #url.maxPrice#
                            )" 
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