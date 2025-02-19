<cfinclude  template="./userHeader.cfm">
<cfif structKeyExists(url, "productId") AND isNumeric(url.productId)>
    <cfset variables.productDetails = application.userObject.getProductDetails(productId=url.productId)>
    <cfif arrayLen(variables.productDetails)>
        <cfoutput>
            <div class="productBody d-flex m-3 align-items-center">
                <div class="productImage">
                    <div id="carouselExampleIndicators" class="carousel slide"> 
                        <div class="carousel-inner">
                            <cfloop array="#variables.productDetails#" item="local.productImage">
                                <div class="carousel-item #(local.productImage.defaultImage)?'active':''#">
                                    <img src="./assets/productimages/#local.productImage.imageFileName#" class="d-block" alt="...">
                                </div>
                            </cfloop>
                        </div>
                        <cfif arrayLen(variables.productDetails) GT 1 >
                            <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleIndicators" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </cfif>
                    </div>
                </div>
                <div class="productDetails my-3 mx-2 px-2 py-3 border d-flex flex-column">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="./category.cfm?catId=#variables.productDetails[1].categoryID#">
                                    #variables.productDetails[1].categoryName#
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="./productListing.cfm?subcatId=#variables.productDetails[1].subCategoryId#">
                                    #variables.productDetails[1].SubcategoryName#
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">#variables.productDetails[1].productName#</li>
                        </ol>
                    </nav>
                    <div class = "m-3" >
                        <h3 class="productName">
                            #variables.productDetails[1].productName#
                        </h3>
                        <p>
                            #variables.productDetails[1].brandName#
                        </p>
                        Description :
                        <div class="description m-1">
                            #variables.productDetails[1].description#
    
                        </div>
                        <div class = " my-2 d-flex flex-column" >
                            <b>Product Price :</b>
                            <span 
                                class="price m-2" 
                                title="#variables.productDetails[1].productPrice# + #variables.productDetails[1].productTax#"
                            >
                                <i class="fa-solid fa-indian-rupee-sign"></i> 
                                #variables.productDetails[1].productPrice + variables.productDetails[1].productTax#
                            </span>
                        </div>
                    </div>
                    <div class = "m-auto d-flex flex-column w-100 productButtons">
                        <div class = "d-flex w-100" >
                            <button 
                                class="btn btn-warning"
                                name="addToCart"
                                onclick="addToCart(#url.productId#)"
                            >
                                ADD  TO CART
                            </button>
                            <button 
                                class="btn btn-primary"
                                name="buyNow"
                                id="buyNow"
                                value="#url.productId#"
                            >
                                BUY NOW
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>
    <cfelse>
        <div class="text-danger text-center">Product not found</div>
    </cfif>
<cfelse>
    <cflocation  url="./errorPage.cfm" addtoken="false">
</cfif>
<cfinclude  template="./userFooter.cfm">