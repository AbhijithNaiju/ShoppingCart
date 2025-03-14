<cfcomponent>
    <!--- add product to cart --->
    <cffunction name = "addToCart" returntype = "struct" returnformat = "json" access="remote">
        <cfargument name = "productid" type = "string" required = "true">
        <cfset local.productId = decrypt(arguments.productId, application.secretKey,'AES', 'Base64')>
        <cfset local.resultStruct = structNew()>
        <cfif structKeyExists(session, "userSession") AND structKeyExists(session.userSession, "userId")>
            <!--- user is logged in --->
            <!--- checking whether product already in the cart --->
            <cfquery name = "local.isProductExist">
                SELECT 
                    fldCart_ID
                FROM 
                    tblCart
                WHERE
                    fldProductId = <cfqueryparam value = "#local.productId#" cfSqlType = "integer">
                    AND
                    fldUserId = <cfqueryparam value = "#session.userSession.userId#" cfSqlType = "integer">
            </cfquery>
            <cfif local.isProductExist.recordCount>
                <!--- product is present in cart(increase quantity) --->
                <cfquery>
                    UPDATE 
                        tblCart
                    SET
                        fldQuantity=fldQuantity+1
                    WHERE
                        fldCart_Id=<cfqueryparam value = "#local.isProductExist.fldCart_ID#" cfSqlType = "integer">
                </cfquery>
            <cfelse>
                <!--- product is not present in cart(add product) --->
                <cfquery>
                    INSERT INTO
                        tblCart(
                            fldproductId,
                            fldQuantity,
                            fldUserId
                        )VALUES(
                            <cfqueryparam value = "#local.productId#" cfSqlType = "integer">,
                            1,
                            <cfqueryparam value = "#session.userSession.userId#" cfSqlType = "integer">
                        );
                </cfquery>
                <cfset session.userSession.cartCount += 1>
            </cfif>
            <cfset local.resultStruct["cartCount"] = session.userSession.cartCount>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <!--- user is not loged in --->
            <cfset local.resultStruct["redirect"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Update quantity in cart --->
    <cffunction name = "updateCartQnty" returntype = "struct" returnformat = "json" access = "remote">
        <cfargument name = "cartId" type = "integer" required = "true">
        <cfargument name = "quantityChange" type = "integer" required = "true">
        <cfset local.resultStruct = structNew()>

        <cfquery name = "local.getCartItemQuantity">
            SELECT
                C.fldQuantity AS cartItemQuantity,
                P.fldPrice AS unitPrice,
                (P.fldPrice*P.fldTax/100) AS unitTax
            FROM 
                tblCart C
            INNER JOIN tblProduct P ON P.fldProduct_ID = C.fldProductId AND P.fldActive = 1
            WHERE 
                C.fldCart_id=<cfqueryparam value = "#arguments.cartId#" cfSqlType = "integer">;
        </cfquery>
            <cfset local.resultStruct["unitPrice"] = local.getCartItemQuantity.unitPrice>
            <cfset local.resultStruct["unitTax"] = local.getCartItemQuantity.unitTax>
        <cfif local.getCartItemQuantity.cartItemQuantity EQ 1 AND arguments.quantityChange EQ -1>
            <cfset local.resultStruct["cartItemQuantity"] = local.getCartItemQuantity.cartItemQuantity>
            <cfset local.resultStruct["error"] = "Unable to set quatity to 0">
        <cfelse>
            <cfquery>
                UPDATE 
                    tblCart
                SET
                    fldQuantity = 
                CASE 
                    WHEN <cfqueryparam value="#arguments.quantityChange#" cfsqltype="varchar"> = '1' THEN fldQuantity + 1
                    WHEN <cfqueryparam value="#arguments.quantityChange#" cfsqltype="varchar"> = '-1' THEN fldQuantity - 1
                    ELSE fldQuantity
                END
                WHERE
                    fldCart_Id=<cfqueryparam value = "#arguments.cartId#" cfSqlType = "integer">
            </cfquery>
            <cfset local.resultStruct["success"] = true>
            <cfif arguments.quantityChange EQ -1>
                <cfset local.resultStruct["cartItemQuantity"] = local.getCartItemQuantity.cartItemQuantity-1>
            <cfelseif arguments.quantityChange EQ 1>
                <cfset local.resultStruct["cartItemQuantity"] = local.getCartItemQuantity.cartItemQuantity+1>
            <cfelse>
                <cfset local.resultStruct["cartItemQuantity"] = local.getCartItemQuantity.cartItemQuantity>
            </cfif>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Get items in cart --->
    <cffunction name = "getCartItems" returntype = "query">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfquery name = "local.cartItems">
            SELECT
                C.fldCart_ID AS cartId,
                C.fldQuantity AS quantity,
                C.fldProductId AS productId,
                P.fldProductName AS productName,
                P.fldPrice AS price,
                (P.fldPrice*P.fldTax/100) AS tax,
                PI.fldImageFileName AS imageFileName
            FROM
                tblCart C
            INNER JOIN tblProduct P ON P.fldProduct_ID = C.fldProductId AND P.fldActive = 1
            LEFT JOIN tblProductImages PI ON PI.fldProductId = P.fldProduct_ID AND PI.fldDefaultImage = 1 AND PI.fldActive = 1
            WHERE 
                C.fldUserId = <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">
        </cfquery>
        <cfreturn local.cartItems>
    </cffunction>

    <!--- Delete an item from cart --->
    <cffunction name = "removeFromCart" returntype = "struct" returnformat = "JSON" access = "remote">
        <cfargument name = "cartId" type = "integer" required = "true">
        <cfset local.structResult = structNew()>
        <cfquery result="local.deleteResult">
            DELETE FROM
                tblcart
            WHERE 
                fldCart_ID = <cfqueryparam value = "#arguments.cartId#" cfSqlType = "integer">
        </cfquery>
        <cfif local.deleteResult.recordCount>
            <cfset session.userSession.cartCount -= 1>
        </cfif>
        <cfset local.structResult["success"] = true>
        <cfset local.structResult["cartCount"] = session.userSession.cartCount>
        <cfreturn local.structResult>
    </cffunction>
</cfcomponent>