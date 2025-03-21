<cfcomponent>
<cffunction name = "getProductData" returntype = "query">
        <cfargument name = "productId" type = "integer" required = "true">
        
        <cfquery name = "local.getProducts" returntype="query">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                PI.fldDefaultImage AS defaultImage,
                P.fldPrice AS Price,
                (P.fldPrice*P.fldTax/100) AS Tax,
                PI.fldImageFileName AS imageFileName
            FROM
                tblProduct P
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId 
                AND PI.fldActive = 1
                AND PI.fldDefaultImage = 1 
            WHERE
                P.fldActive=1
                AND
                P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
        </cfquery>
        <cfreturn local.getProducts>
    </cffunction>

    <!--- Place order --->
    <cffunction name = "placeOrder" returntype = "struct">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "orderAddressId" type = "integer" required = "true">
        <cfargument name = "cardNumber" type = "numeric" required = "true">
        <cfargument name = "cardCVV" type = "numeric" required = "true">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfargument name = "quantity" type = "integer" required = "true">

        <cfset local.cardNumber = "1122334455667788">
        <cfset local.cardCVV = "123">
        <cfset local.resultStruct = structNew()>
        <cfif arguments.cardNumber EQ local.cardNumber AND arguments.cardCVV EQ local.cardCVV>
            <cfset local.UUID = createUUID()>
            <cfset local.cardLastFour = right(arguments.cardNumber, 4)>
            <cfstoredproc
                procedure = "placeOrderTest" 
            >
                <cfprocparam 
                    CFSQLType = "integer"
                    type = "in" 
                    value = "#arguments.userId#"
                >
                <cfprocparam 
                    CFSQLType = "integer"
                    type = "in" 
                    value = "#arguments.orderAddressId#"
                >
                <cfprocparam 
                    CFSQLType = "integer"
                    type = "in" 
                    value = "#local.cardLastFour#"
                >
                <cfprocparam 
                    CFSQLType = "varchar"
                    type = "in" 
                    value = "#local.UUID#"
                >
                <cfprocparam 
                    CFSQLType = "varchar"
                    type = "in" 
                    value = "#arguments.productId#"
                >
                <cfprocparam 
                    CFSQLType = "varchar"
                    type = "in" 
                    value = "#arguments.quantity#"
                >
                <cfprocparam 
                    CFSQLType = "bit"
                    type = "out" 
                    variable = "local.isOrderSuccess"
                >
            </cfstoredproc>
            <cfif structKeyExists(local, "isOrderSuccess") AND len(local.isOrderSuccess)>
                <cfif arguments.productId EQ 0>
                    <cfset session.userSession.cartCount = 0>
                </cfif>
                <cfset local.orderDetails = getOrderHistory(userId=arguments.userId,orderId=local.UUID)>
                <!--- Sending mail if order placed --->
                <cfmail  
                    from="shoppingCart@gmail.com"  
                    subject="Order placed"  
                    to="#session.userSession.emailId#"
                    type="html"
                >
                    <cfmailpart type="text/html">
                        <html>
                            <head>
                                <style>
                                    .pdfHeader{
                                        padding: 20px;
                                        font-size:22px;
                                    }
                                    table{
                                        text-align: center;
                                        width:100%;
                                    }
                                    th,td{
                                        text-align:center;
                                        padding:10px;
                                        border:1px solid ##000;
                                    }
                                    .invoiceBody{
                                        padding:3px;
                                    }
                                    .addressDetails{
                                        font-size: 14px;
                                        margin-top:10px;
                                        text-align:left;
                                    }
                                    .priceDetails{
                                        text-align:right;
                                    }
                                    .orderDate{
                                        text-align:left;
                                    }
                                </style>
                            </head>
                            <body>
                                <h3>Dear #session.userSession.name#,</h3>
                                <p>Your order placed successfully.</p>
                                <p>Order ID : #local.UUID#</p>
                                    <table border=1 style="width:100%;">
                                        <thead>
                                            <tr>
                                                <th>Product Name</th>
                                                <th>Brand</th>
                                                <th>Quantity</th>
                                                <th>Price</th>
                                                <th>Tax</th>
                                                <th>Total Cost</th>
                                            </tr>
                                        </thead>
                                        <cfloop query="local.orderDetails">
                                            <tr>
                                                <td>#local.orderDetails.productName#</td>
                                                <td>#local.orderDetails.brandName#</td>
                                                <td>#local.orderDetails.Quantity#</td>
                                                <td>#local.orderDetails.unitPrice#</td>
                                                <td>#numberFormat(local.orderDetails.unitTax,'__.00')#</td>
                                                <td>#(local.orderDetails.unitPrice + local.orderDetails.unitTax)*local.orderDetails.quantity#</td>
                                            </tr>
                                        </cfloop>
                                    </table>
                                    <div class = "orderDate">
                                        Order Date : #local.orderDetails.orderDate#
                                    </div>
                                    <div class = "addressDetails">
                                        <b>Address details :</b>
                                        <div>
                                            #local.orderDetails.firstName & ' ' & local.orderDetails.lastName#
                                        </div>
                                        <div>
                                            #local.orderDetails.addressLine1 & ', '#
                                            <cfif LEN(local.orderDetails.addressLine2)>
                                                # local.orderDetails.addressLine2 & ', '#
                                            </cfif>
                                            # local.orderDetails.city#
                                            #local.orderDetails.state & ' - ' & local.orderDetails.pincode#
                                        </div>
                                        <div>Phone : #local.orderDetails.phoneNumber#</div>
                                    </div>
                                    <div class = "priceDetails">
                                        <p>Actual Price : #local.orderDetails.totalPrice#</p>
                                        <p>Total Tax : #local.orderDetails.totalTax#</p>
                                        <hr>
                                        <b>Total Price : #local.orderDetails.totalPrice + local.orderDetails.totalTax#</b>
                                    </div>
                                </div>
                            </body>
                        </html>
                    </cfmailpart>
                </cfmail>
                <cfset local.resultStruct["success"] = true>
            <cfelse>
                <cfset local.resultStruct["emptyCartError"] = "No products available to complete the order please refresh the cart and try again">
            </cfif>
        <cfelse>
            <cfset local.resultStruct["cardError"] = "Invalid Card Details">
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Get details of orders --->
    <cffunction name = "getOrderHistory" returntype = "query">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "orderId" type = "string" required = "false">
        <cfargument name = "orderSearchId" type = "string" required = "false">
        <cfquery name = "local.qryOrderHistory">
            SELECT 
                O.fldOrder_ID AS orderId,
                O.fldTotalPrice AS totalPrice,
                O.fldTotalTax AS totalTax,
                DATE_FORMAT(O.fldOrderDate, '%d/%m/%Y %l:%i %p') AS orderDate,
                OI.fldQuantity AS quantity,
                OI.fldUnitPrice AS unitPrice,
                (OI.fldUnitPrice*OI.fldUnitTax/100) AS unitTax,
                P.fldProduct_ID AS productId,
                P.fldProductName AS productName,
                PI.fldImageFileName AS imageFileName,
                B.fldBrandName AS brandName,
                A.fldFirstName AS firstName,
                A.fldLastName AS lastName,
                A.fldAddressLine1 AS addressLine1,
                A.fldAddressLine2 AS addressLine2,
                A.fldCity AS city,
                A.fldState AS state,
                A.fldPincode AS pincode,
                A.fldPhoneNumber AS phoneNumber
            FROM
                tblOrder O
            INNER JOIN tblOrderItems OI ON OI.fldOrderId = O.fldOrder_ID
            INNER JOIN tblAddress A ON A.fldAddress_ID = O.fldAddressId
            INNER JOIN tblProduct P ON P.fldProduct_ID = OI.fldProductId
            LEFT JOIN tblBrands B ON B.fldBrand_ID = P.fldBrandId
            LEFT JOIN tblProductImages PI ON PI.fldproductId = P.fldProduct_ID AND PI.fldDefaultImage = 1
            WHERE
                O.fldUserId = <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">
                <cfif structKeyExists(arguments, "orderId")>
                    AND
                    O.fldOrder_ID = <cfqueryparam value = "#arguments.orderId#" cfSqlType = "varchar">
                <cfelseif structKeyExists(arguments, "orderSearchId")>
                    AND
                    O.fldOrder_ID like <cfqueryparam value = "%#arguments.orderSearchId#%" cfSqlType = "varchar">
                </cfif>
            ORDER BY
                O.fldOrderDate DESC
        </cfquery>
        <cfreturn local.qryOrderHistory>
    </cffunction>
</cfcomponent>