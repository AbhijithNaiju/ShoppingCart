<cfinclude  template="userHeader.cfm">

<cfset variables.cartItems=application.userObject.getCartItems(userId=session.userId)>
<cfset variables.actualPrice = 0>
<cfset variables.totalTax = 0>
<cfset variables.totalPrice = 0>
<cfoutput>
    <div class="cartBody container h-100">
        <div class="row h-100">
            <div class="col-8 h-100 overflow-scroll pe-4">
                <cfif variables.cartItems.recordCount>
                    <cfloop query="#variables.cartItems#">
                        <div class="cartItem row bg-white my-3" id="cartItem#variables.cartItems.cartId#">
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
                                <div class="qantityButtons">
                                    <button 
                                        class="btn btn-sm btn-primary" 
                                        onclick="changeQuantity(this,{change:-1,cartId:#variables.cartItems.cartId#})"
                                    >   
                                        -
                                    </button>
                                    <input 
                                        class="btn border btn-sm cartQuantity" 
                                        value="#variables.cartItems.quantity#"
                                        readonly
                                    >
                                    <button 
                                        class="btn btn-sm btn-primary" 
                                        onclick="changeQuantity(this,{change:1,cartId:#variables.cartItems.cartId#})"
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
                                        Unit tax : Rs 
                                        <span class="itemTax">
                                            #variables.cartItems.tax#
                                        </span>
                                    </small>
                                    <b>
                                        Total price : Rs 
                                        #variables.cartItems.price+variables.cartItems.tax#
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
                <cfelse>
                    <div class = "text-center m-3">
                        <h2>No items present in cart</h2>
                        <a href="./index.cfm" class="btn btn-primary">Go to Home</a>
                    </div>
                </cfif>
            </div>
            <div class="col-4 totalPriceBody border p-3 mt-5 d-flex flex-column justify-content-around">
                <div class="">
                    <div class="row">
                        <span class="col-6">Actual Price</span>
                        <div  class="col-6 text-end">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            <span id="actualPrice">#variables.actualPrice#</span>
                        </div>
                    </div>
                    <div class="row">
                        <span  class="col-6">Total Tax</span>
                        <div  class="col-6 text-end">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            <span id="totalTax">#variables.totalTax#</span>
                        </div>
                    </div>
                </div>
                <span class="row my-2 grandTotalContainer">
                    <span  class="col-6">Total Price</span>
                    <div  class="col-6 text-end">
                        <i class="fa-solid fa-indian-rupee-sign"></i>
                        <span id="totalPrice">#variables.actualPrice + variables.totalTax#</span>
                    </div>
                </span>
                <cfif variables.cartItems.recordCount>
                    <a href="./orderPage.cfm" id="placeOrder" class="btn btn-primary w-100">Place Order</a>
                </cfif>
            </div>
        </div>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">