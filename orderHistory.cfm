<cfinclude  template="userHeader.cfm">
<cfif 
    structKeyExists(form, "orderSearchButton") 
    AND structKeyExists(form, "orderSearchId")
    AND len(trim(form.orderSearchId))
>
    <cfset variables.orderHistory=application.userObject.getOrderHistory(
        userId=session.userId,
        orderSearchId=form.orderSearchId
    )>
<cfelse>
    <cfset variables.orderHistory=application.userObject.getOrderHistory(
        userId=session.userId
    )>
</cfif>
<cfoutput>
    <div class="container overflow-scroll orderHistoryBody">
        <div class="d-flex justify-content-between align-items-center bg-white">
            <h2>
                <cfif structKeyExists(form, "orderSearchButton")
                    AND structKeyExists(form, "orderSearchId")
                    AND len(trim(form.orderSearchId))
                >
                    Search result for "#form.orderSearchId#"
                <cfelse>
                    Order History
                </cfif>
            </h2>
            <form class="input-group w-50 orderSearch" method="post">
                <input 
                    type="text" 
                    class="form-control form-control-sm" 
                    name="orderSearchId"
                    id="orderSearchField"
                    placeholder="" 
                    aria-label="Search" 
                    aria-describedby="basic-addon2"
                    id="orderSearchId"
                    <cfif structKeyExists(form,"orderSearchId")>
                        value="#form.orderSearchId#"
                    </cfif>
                >
                <div class="input-group-append">
                    <button 
                        class="btn btn-outline-success h-100" 
                        id="orderSearchButton" 
                        type="submit"
                        name = "orderSearchButton"
                    >
                        Search
                    </button>
                    <button 
                        class="btn btn-outline-secondary h-100" 
                        type="submit"
                        name = "orderSearchClearButton"
                        id = "orderSearchClearButton"
                    >
                        Reset
                    </button>
                </div>
            </form>
        </div>
        <cfif variables.orderHistory.recordCount EQ 0>
            <div class="text-center my-2">
                <h3>No order found</h3>
            </div>
        </cfif>
        <div class = "d-flex flex-column" id="orderListingBody">
            <cfloop query="variables.orderHistory" group="orderId">
                <div class = "border d-flex flex-column my-2">
                    <div class = "d-flex justify-content-between align-items-center px-2 w-100 bg-success-subtle">
                        <span class="orderId">ORDER ID : #variables.orderHistory.orderId#</span>
                        <a
                            href="./orderInvoice.cfm?orderId=#variables.orderHistory.orderId#" 
                            class="btn downloadInvoice" 
                            title="Download pdf"
                        >
                            <img src="./assets/images/pdf.png" alt="">
                        </a>
                    </div>
                    <cfquery name = "variables.orderItems" dbtype="query">
                        SELECT
                            quantity,
                            productId,
                            unitPrice,
                            unitTax,
                            productName,
                            imageFileName,
                            brandName
                        FROM
                            variables.orderHistory
                        WHERE
                            orderID = '#variables.orderHistory.orderId#'
                    </cfquery>
                    <div class = "p-1">
                        <cfloop query="variables.orderItems">
                            <div class = "p-2 row">
                                <a 
                                    href="./product.cfm?productId=#variables.orderItems.productId#"
                                    class="col-2 d-flex align-items-center justify-content-center"
                                >
                                    <img 
                                        src="./assets/productimages/#variables.orderItems.imageFileName#" 
                                        alt="image not found"
                                        class="orderHistoryImage"
                                    >
                                </a>
                                <div class="col-5 d-flex flex-column justify-content-around overflow-hidden">
                                    <span class="fw-bold orderItemProductName">
                                        #variables.orderItems.productName#
                                    </span>
                                    <span class="text-secondary orderItemBrand">
                                        Brand : #variables.orderItems.brandName#
                                    </span>
                                    <span class="text-secondary orderItemQuantity">
                                        Quantity : #variables.orderItems.quantity#
                                    </span>
                                </div>
                                <div class="col-5 d-flex flex-column justify-content-around overflow-hidden">
                                    <div class="d-flex flex-column">
                                        <span class="orderHistoryPrice text-secondary">
                                            Unit Price : #variables.orderItems.unitPrice#
                                        </span>
                                        <span class="orderHistoryTax text-secondary">
                                            Unit tax : #variables.orderItems.unitTax#
                                        </span>
                                    </div>
                                    <span class="orderHistoryUnitTotal fw-bold">
                                        Unit total : #variables.orderItems.unitPrice + variables.orderItems.unitTax#
                                    </span>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                    <div class = "d-flex justify-content-between p-2 w-100 bg-body-secondary">
                        <div class = "d-flex flex-column addressDetails">
                            <b>Address details :</b> 
                            <span>
                                #variables.orderHistory.firstName & ' ' & variables.orderHistory.lastName#
                            </span>
                            <span>
                                #variables.orderHistory.addressLine1 & ', '# 
                                #variables.orderHistory.addressLine2 & ', '#
                                #variables.orderHistory.city#
                                #variables.orderHistory.state & ' - ' & variables.orderHistory.pincode#
                            </span>
                            <span>Phone : #variables.orderHistory.phoneNumber#</span>
                        </div>
                        <div class="d-flex flex-column justify-content-between">
                            <div 
                                class="fw-bold"
                                data-bs-toggle="tooltip" 
                                data-bs-placement="top"
                                title="#'Price : ' & variables.orderHistory.totalPrice & ' + Tax : ' & variables.orderHistory.totalTax#"
                            >
                                Total Price : #variables.orderHistory.totalPrice + variables.orderHistory.totalTax#
                            </div>
                            <span class="orderDate"> 
                                Ordered on : 
                                #variables.orderHistory.orderDate#
                            </span>
                        </div>
                    </div>
                </div>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">