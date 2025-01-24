<cfinclude  template="./userHeader.cfm">
<cfif structKeyExists(url, "productId") AND isNumeric(url.productId)>
    <cfif structKeyExists(form, "addToCart")>
        <cfif structKeyExists(session, "userId")>
            <cfset addToCartResult = application.userObject.addToCart(url.productId)>
            <cfif structKeyExists(addToCartResult, "success")>
                <cflocation  url="/cartPage.cfm" addtoken="no">
            </cfif>
        <cfelse>
            <cflocation  url="/login.cfm?redirect=cart&productId=#url.productId#" addtoken="no">
        </cfif>
    </cfif>
    <cfif structKeyExists(form, "buyNow")>
        <cfif structKeyExists(session, "userId")>
            <cflocation  url="/orderPage.cfm?productId=#url.productId#" addtoken="no">
        <cfelse>
            <cflocation  url="/login.cfm?redirect=order&productId=#url.productId#" addtoken="no">
        </cfif>
    </cfif>
    <cfset productDetails = application.userObject.getProductDetails(productId=url.productId)>
    <cfif arrayLen(productDetails)>
        <cfoutput>
            <div class="productBody d-flex">
                <div class="productImage">
                    <div id="carouselExampleIndicators" class="carousel slide"> 
                        <div class="carousel-inner">
                            <cfloop array="#productDetails#" item="local.productImage">
                                <div class="carousel-item #(local.productImage.defaultImage)?'active':''#">
                                    <img src="./assets/productimages/#local.productImage.imageFileName#" class="d-block" alt="...">
                                </div>
                            </cfloop>
                        </div>
                        <cfif arrayLen(productDetails) GT 1 >
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
                    <form method="post">
                        <button 
                            class="btn btn-warning"
                            name="addToCart"
                        >
                            ADD  TO CART
                        </button>
                        <button 
                            class="btn btn-primary"
                            name="buyNow"
                        >
                            BUY NOW
                        </button>
                    </form>
                </div>
                <div class="productDetails my-3 mx-2 px-2 py-3 border">
                    <div class="productNavLinks d-flex">
                        <a 
                            href="./category.cfm?catId=#productDetails[1].categoryID#"
                        >
                            #productDetails[1].categoryName#
                        </a>-
                        <a 
                            href="./productListing.cfm?subcatId=#productDetails[1].subCategoryId#"
                        >
                            #productDetails[1].SubcategoryName#
                        </a>-
                        <a 
                            href=""
                        >
                            #productDetails[1].productName#
                        </a>
                    </div>
                    <div class = "m-3" >
                        <h3 class="productName">
                            #productDetails[1].productName#
                        </h3>
                        <p>
                            #productDetails[1].brandName#
                        </p>
                        Description :
                        <div class="description m-1">
                            #productDetails[1].description#
    
                        </div>
                        <div class = " my-2" >
                            <span 
                                class="price" 
                                title="#productDetails[1].productPrice# + #productDetails[1].productTax#"
                            >
                                <i class="fa-solid fa-indian-rupee-sign"></i> 
                                #productDetails[1].productPrice + productDetails[1].productTax#
                            </span>
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