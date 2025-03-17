<cfinclude template="userHeader.cfm">

<cfparam name="url.sortOrder" default="name">
<cfparam name="url.searchValue" default="">
<cfparam name="url.subcategoryId" default="">
<cfparam name="url.minPrice" default="-1">
<cfparam name="url.maxPrice" default="-1">

<cfif url.minPrice EQ "">
    <cfset url.minPrice = -1>
</cfif>
<cfif url.maxPrice EQ "">
    <cfset url.maxPrice = -1>
</cfif>
<cfif len(url.sortOrder) EQ 0>
    <cfset url.sortOrder = "name">
</cfif>

<cfif len(trim(url.searchvalue)) OR (url.subcategoryId NEQ 0 AND len(url.subcategoryId))>
    <cfif len(url.subcategoryId)>
        <cfset local.decryptedSubcategoryId = application.userObject.decryptId(url.subcategoryId)>
    <cfelse>
        <cfset local.decryptedSubcategoryId = 0>
    </cfif>
    <cfset variables.productList = application.productObject.getProductList(
        searchValue=url.searchValue,
        subcategoryId=local.decryptedSubcategoryId,
        sortOrder=url.sortOrder,
        limit=10,
        count=true,
        minPrice=url.minPrice,
        maxPrice=url.maxPrice
    )>
    <cfoutput>
        <div class="m-3">
            <h3>
                <cfif url.searchValue NEQ "">
                    Search result for "#url.searchValue#"
                <cfelseif url.subcategoryId NEQ 0 AND arrayLen(variables.productList.resultArray)>
                    #variables.productList.resultArray[1].subcategoryName#
                </cfif>
            </h3>
            <form method="get" class="d-flex justify-content-between mx-2">
                <div class="d-flex justify-content-between mx-2">
                    <cfif LEN(url.searchValue)>
                        <input type="hidden" name="searchValue" value="#url.searchValue#" id="searchValue">
                    <cfelseif structKeyExists(url, "subcategoryId")>
                        <input type="hidden" name="subcategoryId" value="#url.subcategoryId#" id="subcategoryId">
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
                        class="btn btn-sm me-1 sortProductsBtn #(url.sortOrder EQ "asc")?"btn-dark":"btn-outline-dark"#"
                        <cfif url.sortOrder EQ "asc">
                            disabled
                        </cfif>
                    >
                        Price : Low to high
                    </button>
                    <button 
                        type="submit" 
                        value="desc" 
                        class="btn btn-sm me-1 sortProductsBtn #(url.sortOrder EQ "desc")?"btn-dark":"btn-outline-dark"#"
                        <cfif url.sortOrder EQ "desc">
                            disabled
                        </cfif>
                    >
                        Price : High to low
                    </button>
                    <cfif url.sortOrder EQ "asc" OR url.sortOrder EQ "desc">
                        <button 
                            type="submit" 
                            class="btn btn-sm btn-outline-danger sortProductsBtn d-flex align-items-center"
                        >
                            Clear
                            <i class="fa-solid fa-xmark mx-1"></i>
                        </button>
                    </cfif>
                </div>
                <div class="dropdown" id="minMaxDropdown">
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
                                name = "filterRadio"
                                id="filter1" 
                                onclick='setFilter({min:0,max:1000})'
                            >
                            <label for="filter1">0 - 1000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                class="filterRadio" 
                                name="filterRadio" 
                                id="filter2" 
                                onclick='setFilter({min:1000,max:10000})'
                            >
                            <label for="filter2">1000 - 10000</label>
                        </li>
                        <li class = "form-control dropdown-item">
                            <input 
                                type="radio" 
                                class="filterRadio" 
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
                                name="minPrice"
                                <cfif LEN(url.minPrice) AND url.minPrice GTE 0>
                                    value="#url.minPrice#"
                                <cfelse>
                                    value=""
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
                                Apply
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
                            href="product.cfm?productId=#urlEncodedFormat(variables.productDetails.productId)#" 
                            class="randomProducts d-flex flex-column justify-content-between align-items-center border shadow-sm"
                        >
                            <div class="card-img-top randomProductImage d-flex align-items-center justify-content-center">
                                <img src="./assets/productimages/#variables.productDetails.imageFileName#"></img>
                            </div>
                            <div class="w-100 d-flex flex-column randomProductsDetails">
                                <h6 class="card-title p-2">#variables.productDetails.productName#</h6>
                                <span class = "productBrand text-secondary px-2">#variables.productDetails.brandName#</span>
                                <span class="mt-auto px-2 randomProductPrice">
                                    Rs :
                                    #numberFormat(variables.productDetails.productPrice + variables.productDetails.productTax,'__.00')#
                                </span>
                            </div>
                        </a>
                    </cfloop>
                </div>
                <cfif variables.productList.resultArray[1].totalCount GT 10>
                    <div class="d-flex justify-content-center">
                        <button
                            class="btn border my-1"
                            id="showMoreBtn"
                            value=#arrayLen(variables.productList.resultArray)#
                        >
                            Show more
                        </button>
                    </div>
                </cfif>
                <div class="text-center" id="listingMessage"></div>
            <cfelse>
                <div class = "text-center" id = "listingMessage">No products found<div>
            </cfif>
        </div>
    </cfoutput>
<cfelse>
    <cflocation url="./missingPage.cfm" addtoken="false">
</cfif>
<cfinclude template="userFooter.cfm">
<script src="./js/productListing.js"></script>