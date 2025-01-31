<cfinclude  template="userHeader.cfm">

<cfset variables.cartItems=application.userObject.getCartItems(userId=session.userId)>
<cfoutput>
    <div class="cartBody container">
        <div class="row h-100">
            <div class="col-8 h-100 overflow-scroll">
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
                </cfloop>
            </div>
            <div class="col-4 border h-50 p-3 d-flex flex-column justify-content-around">
                <div class="">
                    <div class="row">
                        <span class="col-6">Actual Price</span>
                        <div  class="col-6 text-end">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            <span id="actualPrice"></span>
                        </div>
                    </div>
                    <div class="row">
                        <span  class="col-6">Total Tax</span>
                        <div  class="col-6 text-end">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            <span id="totalTax"></span>
                        </div>
                    </div>
                </div>
                <span class="row my-2 grandTotalContainer">
                    <span  class="col-6">Total Price</span>
                    <div  class="col-6 text-end">
                        <i class="fa-solid fa-indian-rupee-sign"></i>
                        <span id="totalPrice"></span>
                    </div>
                </span>
                <button class="btn btn-primary w-100">Place Order</button>
            </div>
        </div>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">