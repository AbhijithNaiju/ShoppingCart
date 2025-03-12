<cfinclude  template="userHeader.cfm">

<cfset variables.cartItems=application.userObject.getCartItems(userId=session.userSession.userId)>
<cfset variables.actualPrice = 0>
<cfset variables.totalTax = 0>
<cfset variables.totalPrice = 0>
<cfoutput>
    <div class="cartBody container ">
        <cfif variables.cartItems.recordCount>
            <div class="row">
                <div class="col-8 pe-4">
                    <cfloop query="#variables.cartItems#">
                        <div class="cartItem row my-2 p-3" id="cartItem#variables.cartItems.cartId#">
                            <div class="col-3 d-flex">
                                <img 
                                    src="./assets/productimages/#variables.cartItems.imageFileName#"
                                    class="cartImage m-auto"
                                >
                            </div>
                            <div class="col-5 cartItemName d-flex flex-column justify-content-around">
                                <a href="./product.cfm?productId=#variables.cartItems.productId#">
                                    #variables.cartItems.productName#
                                </a>
                                <div class="quantityButtons" id="quantityButton#variables.cartItems.cartId#">
                                    <button 
                                        class="btn btn-sm btn-primary reduceQuantity" 
                                        onclick="changeQuantity(-1,#variables.cartItems.cartId#)"
                                    >   
                                        -
                                    </button>
                                    <input 
                                        class="btn border btn-sm cartQuantity" 
                                        value="#variables.cartItems.quantity#"
                                        readonly
                                    >
                                    <button 
                                        class="btn btn-sm btn-primary addQuantity" 
                                        onclick="changeQuantity(1,#variables.cartItems.cartId#)"
                                    >
                                        +
                                    </button>
                                </div>
                            </div>
                            <div class="col-4 d-flex flex-column justify-content-around">
                                <div class="d-flex flex-column justify-content-around">
                                    <small>
                                        Unit price : RS 
                                        <span class="itemPrice">
                                            #variables.cartItems.price#
                                        </span>
                                    </small>
                                    <small>
                                        Unit tax :
                                        <span class="itemTax">
                                            #numberFormat(variables.cartItems.tax,'__.00')#
                                        </span>
                                    </small>
                                    <b>
                                        Total price : Rs
                                        #numberFormat(variables.cartItems.price+variables.cartItems.tax,'__.00')#
                                    </b>
                                </div>
                                <button 
                                    class="btn border border-dark removeButton"
                                    value="#variables.cartItems.cartId#"
                                >
                                    Remove
                                </button>
                            </div>
                        </div>
                        <cfset variables.actualPrice +=variables.cartItems.price*variables.cartItems.quantity>
                        <cfset variables.totalTax += variables.cartItems.tax*variables.cartItems.quantity>
                    </cfloop>
                </div>
                <div class="col-4 totalPriceBody px-3 mt-2 d-flex flex-column justify-content-around">
                    <div>
                        <div class="row">
                            <span class="col-6">Actual Price</span>
                            <div  class="col-6 text-end">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                <span id="actualPrice">
                                    #numberFormat(variables.actualPrice,'__.00')#
                                </span>
                            </div>
                        </div>
                        <div class="row">
                            <span  class="col-6">Total Tax</span>
                            <div  class="col-6 text-end">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                <span id="totalTax">
                                    #numberFormat(variables.totalTax,'__.00')#
                                </span>
                            </div>
                        </div>
                    </div>
                    <span class="row my-2 grandTotalContainer">
                        <span  class="col-6">Total Price</span>
                        <div  class="col-6 text-end">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            <span id="totalPrice">
                                #numberFormat(variables.actualPrice + variables.totalTax,'__.00')#
                            </span>
                        </div>
                    </span>
                    <a href="./orderPage.cfm" id="placeOrder" class="btn btn-primary w-100">Place Order</a>
                </div>
            </div>
        </cfif>
        <div class = "d-flex flex-column align-items-center m-3 emptyCartMessage">
            <cfif variables.cartItems.recordCount EQ 0>
                <img src="./assets/images/empty-cart.png" class="errorMessageImage">
                <h4>No items present in cart</h4>
                <p>Add items to continue</p>
                <a href="./index.cfm" class="btn btn-primary btn-sm">Go to Home</a>
            </cfif>
        </div>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">