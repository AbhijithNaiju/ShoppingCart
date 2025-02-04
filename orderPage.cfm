<cfinclude  template="userHeader.cfm">

<cfif structKeyExists(form, "placeOrder")>
    <cfif structKeyExists(form, "orderAddressId")>
        <cfset variables.placeOrder = application.userObject.placeOrder(
            userId = session.userId,
            orderAddressId = form.orderAddressId,
            cardNumber = form.cardNumber,
            cardCVV = form.cardCVV
        )>
    <cfelse>
        <cfset variables.addressError = "Please enter delivery address to continue">
    </cfif>
<cfelseif structKeyExists(form,"addAddress")>
    <cfset variables.addAddressResult = application.userObject.addAddress(
        userId = session.userId,
        formStruct = form
    )>
</cfif>
<cfset variables.cartItems=application.userObject.getCartItems(userId=session.userId)>
<cfset variables.addressList=application.userObject.getAddressListDetails(userId=session.userId)>
<cfif variables.cartItems.recordCount>
    <cfoutput>
    <form method="post" class="orderBody container h-100 overflow-scroll">
        <div class="accordion" id="orderAccordion">
            <div class="accordion-item">
                <h2 class="accordion-header">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
                    Delivery Address
                </button>
                </h2>
                <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="##orderAccordion">
                    <div class = "my-1 accordion-body">
                        <h2>Delivery Address</h2>
                        <div class = "border p-3 d-flex justify-content-between align-items-center">
                            <div class="d-flex flex-column" id = "selectedAddress">
                                <cfif arrayLen(variables.addressList)>
                                    <span class="addressName">#variables.addressList[1].firstName & ' ' & variables.addressList[1].lastName#</span>
                                    <span>
                                        #variables.addressList[1].addressLine1 & ', '#
                                        <cfif structKeyExists(variables.addressList[1],"addressLine2")>
                                            #variables.addressList[1].addressLine2 & ', '#
                                        </cfif>
                                        #variables.addressList[1].city & ', '#
                                        #variables.addressList[1].state & ', '#
                                        #variables.addressList[1].pincode#
                                    </span>
                                    <span>#variables.addressList[1].phoneNumber#</span>
                                <cfelse>
                                    <div class = "text-center text-danger">
                                        <cfif structKeyExists(variables,"addressError")>
                                            #variables.addressError#
                                        <cfelse>
                                            No address available, add address to continue
                                        </cfif>
                                    </div>
                                </cfif>
                            </div>
                            <div class = "d-flex flex-column">
                                <cfif arrayLen(variables.addressList)>
                                    <button 
                                        type = "button"
                                        class = "btn link-primary"
                                        id = "changeAddress"
                                    >
                                        Change
                                    </button>
                                </cfif>
                                <button 
                                    type = "button"
                                    class = "btn link-primary"
                                    id = "orderAddAddress"
                                >
                                    Add address
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                    Order Summary
                </button>
                </h2>
                <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="##orderAccordion">
                    <div class="accordion-body">
                        <cfloop query="#variables.cartItems#">
                            <div class="cartItem orderItem row bg-white my-3" id="cartItem#variables.cartItems.cartId#">
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
                    <div class="my-1">
                        <div class="border p-3 d-flex flex-column justify-content-around">
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
                        </div>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="##collapseThree" aria-expanded="false" aria-controls="collapseThree">
                    Card details
                </button>
                </h2>
                <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="##orderAccordion">
                    <div class=" my-1">
                        <div class="border p-3">
                            <h2>Card details</h2>
                            <div class="row g-3">
                                <div class="col-6">
                                    <label for="" class="form-label">Card Number</label>
                                    <input 
                                        type="text" 
                                        name="cardNumber" 
                                        id="cardNumber" 
                                        class="form-control cardData" 
                                        minlength="16"
                                        maxlength="16"
                                        pattern="[0-9]{16}"
                                        required
                                    >
                                </div>
                                <div class="col-6">
                                    <label for="" class="form-label">CVV</label>
                                    <input 
                                        type="password" 
                                        class="form-control cardData" 
                                        name="cardCVV" 
                                        id="cardCVV" 
                                        placeholder="CVV" 
                                        aria-describedby="cvvHelp" 
                                        required
                                        minlength="3"
                                        maxlength="3"
                                        pattern="[0-9]{3}"
                                    >
                                    <div id="cvvHelp" class="form-text">
                                        3 digit code printed on the back of your card
                                    </div>
                                </div>
                                <div class="text-center errorMessage m-2" id="cardError"></div>
                                <cfif variables.cartItems.recordCount AND arrayLen(variables.addressList)>
                                    <div class="col-12 d-flex justify-content-end">
                                        <button 
                                            type="submit" 
                                            class="btn btn-warning w-25" 
                                            name = "placeOrder"
                                            id="placeOrder"
                                        >
                                        Place Order
                                        </button>
                                    </div>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class = "text-center errorMessage my-2" id="orderError">
            <cfif structKeyExists(variables,"placeOrder") AND structKeyExists(variables.placeOrder, "error")>
                #variables.placeOrder.error#
            </cfif>
        </div>
        <div id="selectAddressModal" class="displayNone">
            <div id="selectAddressBody">
                <div class="selectAddressBody overflow-scroll">
                    <div class="closeSelectAddress w-100 d-flex">
                        <button type="button" class="btn btn-light ms-auto m-1" id = "closeSelectAddress">
                            <i class="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                    <cfloop array="#variables.addressList#" item="variables.addressItem" index="variables.addressIndex">
                        <div 
                            class = "border p-3 d-flex align-items-center" 
                            id="addressItem#variables.addressItem.addressId#"
                        >
                            <input 
                                type = "radio" 
                                name = "orderAddressId" 
                                class = "orderAddress mx-1" 
                                value = "#variables.addressItem.addressId#"
                                id="addressRadio#variables.addressItem.addressId#"
                                #(variables.addressIndex EQ 1)?'checked':''#
                            >
                            <label class="d-flex flex-column ms-1" for="addressRadio#variables.addressItem.addressId#">
                                <span class="addressName">
                                    #variables.addressItem.firstName & ' ' & variables.addressItem.lastName#
                                </span>
                                <span class = "addressDetails">
                                    #variables.addressItem.addressLine1 & ', '#
                                    <cfif structKeyExists(variables.addressItem,"addressLine2")>
                                        #variables.addressItem.addressLine2 & ', '#
                                    </cfif>
                                    #variables.addressItem.city & ', '#
                                    #variables.addressItem.state & ', '#
                                    #variables.addressItem.pincode#
                                </span>
                                <span class = "addressPhone">#variables.addressItem.phoneNumber#</span>
                            </label>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
    </form>
    <div id="addAddressModal" class="displayNone">
        <div id="addAddressBody">
            <form method="post" class = "profileModalBody overflow-scroll">
                <div class="m-4">
                    <div class="form-group my-2">
                        <label for="">First Name</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        name="firstName"
                        required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Last Name</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="lastName"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 1</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine1"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 2</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine2"
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">City</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="city"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">State</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="state"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Phone Number</label>
                        <input 
                            type="tel" 
                            class="form-control"  
                            name="phoneNumber"
                            minlength="8"
                            pattern="[0-9]{10}"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Pincode</label>
                        <input 
                            type="tel" 
                            class="form-control" 
                            name="pincode"
                            minlength="6"
                            pattern="[0-9]{6}"
                            required
                        >
                    </div>
                </div>
                <div class="addressFooter w-100 d-flex bg-white">
                    <button type="reset" class="btn btn-secondary m-2 w-50" id = "closeAddAddress">Close</button>
                    <button type="submit" class="btn btn-primary m-2 w-50" name = "addAddress">Add</button>
                </div>
            </form>
        </div>
    </div>
    </cfoutput>
<cfelse>
    <cfif structKeyExists(variables,"placeOrder") AND structKeyExists(variables.placeOrder, "success")>
        <div class = "text-center m-3">
            <h2>Order placed Successfully</h2>
            <p>Check your email for your order Confirmation</p>
            <a href="./index.cfm" class="btn btn-primary">Go to Home</a>
        </div>
    <cfelse>
        <div class = "text-center m-3">
            <h2>No products available to order please add products to continue</h2>
            <a href="./index.cfm" class="btn btn-primary">Go to Home</a>
        </div>
    </cfif>
</cfif>
<cfinclude  template="userFooter.cfm">