<cfcomponent>
    <!--- user signup --->
    <cffunction  name = "userSignup" returntype = "struct">
        <cfargument  name="firstName" type ="string" required = "true">
        <cfargument  name="lastName" type ="string" required = "true">
        <cfargument  name="emailId" type ="string" required = "true">
        <cfargument  name="phoneNumber" type ="string" required = "true">
        <cfargument  name="password" type ="string" required = "true">

        <cfset local.structResult = structNew()>

        <cfif 
            len(trim(arguments.firstName))
            AND 
            len(trim(arguments.lastName))
            AND 
            len(trim(arguments.emailId))
            AND 
            len(trim(arguments.phoneNumber))
            AND
            len(trim(arguments.password) GT 8)
        >
            <cfquery name="local.isEmailExist">
                SELECT
                    fldUser_ID
                FROM
                    tbluser
                WHERE 
                    fldemail = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
                    OR
                    fldPhone = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
            </cfquery>

            <cfif local.isEmailExist.recordCount>
                <cfset local.structResult["error"] = "Email already exists">
            <cfelse>
                <cfset local.saltString = generateSecretKey("AES")>
                <cfset local.hashedPassword =hash(arguments.password & local.saltString,'SHA-512', 'utf-8', 125)>
                <cfquery result="local.signUpresult">
                    INSERT INTO
                        tbluser(
                            fldFirstName,
                            fldLastName,
                            fldPhone,
                            fldEmail,
                            fldHashedPassword,
                            fldUserSaltString,
                            fldRoleId
                        )VALUES(
                            <cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#arguments.lastName#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#arguments.phoneNumber#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#local.hashedPassword#' cfsqltype = "varchar">,
                            <cfqueryparam value = '#local.saltString#' cfsqltype = "varchar">,
                            2
                        );
                </cfquery>
                <cfset local.structResult["success"] = true>
                <cfset session.userId = local.signUpresult.generatedKey>
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please fill all the fields">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <!--- userlogin --->
    <cffunction  name="userLogin" returntype="struct">
        <cfargument  name="username" type = "string" required = "true">
        <cfargument  name="password" type = "string" required = "true">

        <cfset local.structResult = structNew()>

        <cfif len(trim(arguments.username)) AND len(trim(arguments.password))>
            <cfquery name="local.userDetails">
                SELECT
                    fldUser_ID,
                    fldHashedPassword,
                    fldUserSaltString
                FROM
                    tblUser
                WHERE(
                    fldPhone=<cfqueryparam value = '#arguments.userName#' cfsqltype = "varchar">
                    OR
                    fldEmail=<cfqueryparam value = '#arguments.userName#' cfsqltype = "varchar">
                )
                    AND 
                    fldRoleId=2
                    AND
                    fldActive=1;
            </cfquery>
            <cfif local.userDetails.recordCount>
                <cfif 
                    local.userDetails.fldHashedPassword
                    EQ
                    hash(arguments.password & local.userDetails.fldUserSaltString,'SHA-512', 'utf-8', 125)
                >
                    <cfset session.userId = local.userDetails.fldUser_ID>
                    <cfset local.structResult["success"] = true>
                <cfelse>
                    <cfset local.structResult["error"] = "Invalid password">
                </cfif>
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please enter username and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

    <!--- logout --->
    <cffunction  name="logOut" returntype="struct" returnformat = "json" access="remote">
        <cfset structClear(session)>
        <cfset local.logOutResult["success"] = true>
        <cfreturn local.logOutResult>
    </cffunction>

    <!--- subcategory list for nav bar in header --->
    <cffunction name = "getAllSubcategories" returntype = "query">
        <cfquery  name = "local.getAllSubcategories">
            SELECT 
                SC.fldSubcategory_ID AS subcategoryId,
                SC.fldSubcategoryName AS subcategoryName,
                C.fldCategory_ID AS categoryId,
                C.fldCategoryName AS categoryName
            FROM
                tblCategory C
            INNER JOIN tblSubCategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            WHERE
                C.fldActive=1
        </cfquery>
        <cfreturn local.getAllSubcategories>
    </cffunction>
    
    <!--- get products from categoryid/get random 10 products --->
    <cffunction name = "getCategoryProducts" returntype = "query">
        <cfargument  name = "categoryId" type = "integer" required = "false">
        <cfquery  name = "local.getCategoryProducts">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                P.fldTax AS productTax,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                SC.fldSubcategory_ID AS subcategoryId,
                SC.fldSubcategoryName AS subcategoryName,
                C.fldCategoryName AS categoryName
            FROM
                tblCategory C
            INNER JOIN tblSubcategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            <cfif structKeyExists(arguments,"categoryId")>
                LEFT JOIN tblProduct P ON SC.fldSubcategory_ID = P.fldSubcategoryId AND P.fldActive = 1
            <cfelse>
                INNER JOIN tblProduct P ON SC.fldSubcategory_ID = P.fldSubcategoryId AND P.fldActive = 1
            </cfif>
            LEFT JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1 AND PI.fldActive = 1
            WHERE
                C.fldActive=1
                <cfif structKeyExists(arguments, "categoryId")>
                    AND
                    C.fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                </cfif>
            ORDER BY
            <cfif structKeyExists(arguments,"categoryId")>
                fldSubcategory_ID,
                RAND()
            <cfelse>
                RAND()
                LIMIT 10
            </cfif>
        </cfquery>
        <cfreturn local.getCategoryProducts>
    </cffunction>

    <!--- Details to set header --->
    <cffunction name = "headerDetails" returntype = "struct" access = "remote" returnformat = "json">
        <cfif structKeyExists(session,"userId")>
            <cfset local.resultStruct["sessionExist"] = true>
            <cfquery  name = "local.getCartCount">
                SELECT 
                    count(fldCart_ID) AS cartCount
                FROM
                    tblCart
                WHERE
                    fldUserId = <cfqueryparam value = "#session.userId#" cfSqlType = "integer">
            </cfquery>
            <cfset local.resultStruct["cartCount"] = local.getCartCount.cartCount>
        <cfelse>
            <cfset local.resultStruct["sessionExist"] = false>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- get list of products for productListingPage --->
    <cffunction name = "getProductList" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument  name = "subcategoryId" type = "integer" required = "false">
        <cfargument  name = "searchValue" type = "string" required = "false">
        <cfargument  name = "sortOrder" type = "string" required = "false">
        <cfargument  name = "minPrice" type = "float" required = "false">
        <cfargument  name = "maxPrice" type = "float" required = "false">
        <cfargument  name = "excludedIdList" type = "string" required = "false">
        <cfset local.resultStruct = structNew()>
        <cfquery  name = "local.getProducts" returntype="struct">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                P.fldTax AS productTax,
                P.fldSubcategoryId AS subCategoryId,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                SC.fldSubcategoryName AS subcategoryName
            FROM
                tblCategory C
            INNER JOIN tblSubcategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            LEFT JOIN tblProduct P ON SC.fldSubcategory_ID = P.fldSubcategoryId AND P.fldActive = 1
            LEFT JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1 AND PI.fldActive = 1
            WHERE
                C.fldActive=1
                <cfif structKeyExists(arguments, "subcategoryId")>
                    AND
                    SC.fldSubcategory_ID = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "excludedIdList") AND len(arguments.excludedIdList)>
                    AND
                    P.fldProduct_ID NOT IN (<cfqueryparam value = "#arguments.excludedIdList#" list="true" cfSqlType = "integer">)
                </cfif>
                <cfif structKeyExists(arguments, "searchValue") AND len(arguments.searchValue)>
                    AND(
                        P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                        OR
                        P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                        OR
                        B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                    )
                </cfif>
                <cfif structKeyExists(arguments, "minPrice") AND val(arguments.minPrice) GTE 0>
                    AND
                    (P.fldPrice+P.fldTax) >= <cfqueryparam value = '#val(arguments.minPrice)#' cfSqlType = "decimal" scale="2">
                </cfif>
                <cfif structKeyExists(arguments, "maxPrice") AND val(arguments.maxPrice) GTE 0>
                    AND
                    (P.fldPrice+P.fldTax) <= <cfqueryparam value = '#val(arguments.maxPrice)#' cfSqlType = "decimal" scale="2">
                </cfif>
                ORDER BY
                    <cfif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "asc">
                        (P.fldPrice+P.fldTax) ASC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "desc">
                        (P.fldPrice+P.fldTax) DESC
                    <cfelse>
                        RAND()
                    </cfif>
                <cfif NOT (
                    structKeyExists(arguments, "excludedIdList") 
                    OR structKeyExists(arguments, "minPrice") 
                    OR structKeyExists(arguments, "maxPrice")
                )>
                    LIMIT 10
                </cfif>
        </cfquery>
        <cfif NOT (
            structKeyExists(arguments, "excludedIdList") 
            OR structKeyExists(arguments, "minPrice") 
            OR structKeyExists(arguments, "maxPrice")
        )>
            <cfquery name = "local.totalProducts">
                SELECT
                    COUNT(*) AS productCount
                FROM
                    tblProduct P
                INNER JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID AND SC.fldActive = 1
                INNER JOIN tblCategory C ON SC.fldCategoryId = C.fldCategory_ID AND C.fldActive = 1
                INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
                WHERE
                    P.fldActive=1
                    <cfif structKeyExists(arguments, "subcategoryId")>
                        AND
                        P.fldSubcategoryId = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "searchValue") AND len(arguments.searchValue)>
                        AND(
                            P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                            OR
                            P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                            OR
                            B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                        )
                    </cfif>
                ORDER BY
                    <cfif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "asc">
                        (P.fldPrice+P.fldTax) ASC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "desc">
                        (P.fldPrice+P.fldTax) DESC
                    <cfelse>
                        RAND()
                    </cfif>
            </cfquery>
            <cfset local.resultStruct["productCount"] = local.totalProducts.productCount>
        </cfif>
        <cfset local.resultStruct["resultArray"] = local.getProducts.resultSet>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- get details of single product --->
    <cffunction name = "getProductDetails" returntype = "array">
        <cfargument  name = "productId" type = "integer" required = "true">
            <cfquery  name = "local.productDetails" returnType="struct">
                SELECT 
                    P.fldproductName AS productName,
                    P.fldDescription AS description,
                    P.fldPrice AS productPrice,
                    P.fldTax AS productTax,
                    B.fldBrandName AS brandName,
                    PI.fldImageFileName AS imageFileName,
                    PI.fldDefaultImage AS defaultImage,
                    P.fldSubcategoryId AS subCategoryId,
                    C.fldCategoryname AS categoryName,
                    C.fldCategory_ID AS categoryId,
                    SC.fldSubcategoryname AS SubcategoryName
                FROM
                    tblProduct P
                INNER JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID AND SC.fldActive = 1
                INNER JOIN tblCategory C ON SC.fldCategoryId = C.fldCategory_ID AND C.fldActive = 1
                INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
                LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldActive=1
                WHERE
                    P.fldActive=1
                    AND
                    P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
            </cfquery>
        <cfreturn local.productDetails.resultSet>
    </cffunction>

    <!--- add product to cart --->
    <cffunction name = "addToCart" returntype = "struct" returnformat = "json" access="remote">
        <cfargument  name = "productid" type = "integer" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfif structKeyExists(session, "userId")>
            <!--- user is logged in --->
            <!--- checking whether product already in the cart --->
            <cfquery  name = "local.isProductExist">
                SELECT 
                    fldCart_ID,
                    fldQuantity
                FROM 
                    tblCart
                WHERE
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
                    AND
                    fldUserId = <cfqueryparam value = "#session.userId#" cfSqlType = "integer"> 
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
                <cfset local.resultStruct["increasedItemCount"] = 0>
            <cfelse>
                <!--- product is not present in cart(add product) --->
                <cfquery>
                    INSERT INTO
                        tblCart(
                            fldproductId,
                            fldQuantity,
                            fldUserId
                        )VALUES(
                            <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">,
                            1,
                            <cfqueryparam value = "#session.userId#" cfSqlType = "integer">
                        );
                </cfquery>
                <cfset local.resultStruct["increasedItemCount"] = 1>
                <cfset local.resultStruct["success"] = true>
            </cfif>
        <cfelse>
            <!--- user is not loged in --->
            <cfset local.resultStruct["redirect"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction name = "updateCartQnty" returntype = "struct" returnformat = "json" access = "remote">
        <cfargument name = "cartId" type = "integer" required = "true">
        <cfargument name = "quantityChange" type = "integer" required = "true">
        <cfset local.resultStruct = structNew()>
        <cfquery>
            UPDATE 
                tblCart
            SET
                <cfif arguments.quantityChange EQ 1>
                    fldQuantity=fldQuantity+1
                <cfelseif arguments.quantityChange EQ -1>
                    fldQuantity=fldQuantity-1
                </cfif>
            WHERE
                fldCart_Id=<cfqueryparam value = "#arguments.cartId#" cfSqlType = "integer">
        </cfquery>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>
    <!--- Get items in cart --->
    <cffunction name = "getcartItems" returntype = "query">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfquery name = "local.cartItems">
            SELECT
                C.fldCart_ID AS cartId,
                C.fldQuantity AS quantity,
                C.fldProductId AS productId,
                P.fldProductName AS productName,
                P.fldPrice AS price,
                P.fldTax AS tax,
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
        <cfquery>
            DELETE FROM
                tblcart
            WHERE 
                fldCart_ID = <cfqueryparam value = "#arguments.cartId#" cfSqlType = "integer">
        </cfquery>
        <cfset local.structResult["success"] = true>
        <cfreturn local.structResult>
    </cffunction>

    <!---  Get details of user for profile page --->
    <cffunction name = "getProfileDetails" returntype = "struct">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfquery name = "local.qryProfileDetails" returntype = "struct">
            SELECT
                fldFirstName AS firstName,
                fldLastName AS lastName,
                fldEmail AS email,
                fldPhone AS phone
            FROM
                tblUser
            WHERE
                fldUser_ID = <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">
                AND
                fldActive = 1;

        </cfquery>
        <cfreturn local.qryProfileDetails.resultSet[1]>
    </cffunction>

    <!--- Get address list of user --->
    <cffunction name = "getAddressListDetails" returntype = "array">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfquery name = "local.qryaddressList" returntype = "struct">
            SELECT
                fldAddress_ID AS addressId,
                fldFirstName AS firstName,
                fldLastName AS lastName,
                fldAddressLine1 AS addressLine1,
                fldAddressLine2 AS addressLine2,
                fldCity AS city,
                fldState AS state,
                fldPincode AS pincode,
                fldPhoneNumber AS phoneNumber
            FROM
                tblAddress
            WHERE
                fldUserId = <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">
                AND
                fldActive = 1;

        </cfquery>
        <cfreturn local.qryaddressList.resultSet>
    </cffunction>

    <cffunction name = "updateProfile" returntype = "struct">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "formStruct" type = "struct" required = "true">
        <cfset local.resultStruct = structNew()>

        <cfif 
            len(trim(arguments.formStruct.firstName))
            AND 
            len(trim(arguments.formStruct.lastName))
            AND 
            len(trim(arguments.formStruct.emailId))
            AND 
            isValid("email", arguments.formStruct.emailId)
            AND
            len(trim(arguments.formStruct.phoneNumber))
        >
            <cfquery name="local.isEmailExist">
                SELECT
                    fldUser_ID
                FROM
                    tbluser
                WHERE 
                    fldemail = <cfqueryparam value = "#arguments.formStruct.emailId#" cfSqlType= "varchar">
                    AND
                    NOT fldUser_ID = <cfqueryparam value = "#arguments.userId#" cfSqlType= "varchar">;
            </cfquery>

            <cfif local.isEmailExist.recordCount>
                <cfset local.structResult["error"] = "Email already exists">
            <cfelse>
                <cfquery result="local.signUpresult">
                    UPDATE
                        tbluser
                    SET
                        fldFirstName = <cfqueryparam value = '#arguments.formStruct.firstName#' cfsqltype = "varchar">,
                        fldLastName = <cfqueryparam value = '#arguments.formStruct.lastName#' cfsqltype = "varchar">,
                        fldPhone = <cfqueryparam value = '#arguments.formStruct.phoneNumber#' cfsqltype = "varchar">,
                        fldEmail = <cfqueryparam value = '#arguments.formStruct.emailId#' cfsqltype = "varchar">
                    WHERE 
                        flduser_ID = <cfqueryparam value = "#arguments.userId#" cfSqlType= "varchar">;
                </cfquery>
                <cfset local.structResult["success"] = true>
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please fill all the fields">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction name = "addAddress" returntype = "struct">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "formStruct" type = "struct" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfif 
            len(trim(arguments.formStruct.firstName))
            AND 
            len(trim(arguments.formStruct.lastName))
            AND 
            len(trim(arguments.formStruct.addressLine1))
            AND 
            len(trim(arguments.formStruct.addressLine2))
            AND 
            len(trim(arguments.formStruct.city))
            AND 
            len(trim(arguments.formStruct.state))
            AND 
            len(trim(arguments.formStruct.phoneNumber))
            AND 
            len(trim(arguments.formStruct.pincode))
        >
            <cfquery name = "">
                INSERT INTO 
                    tbladdress( 
                        fldUserId, 
                        fldFirstName, 
                        fldLastName, 
                        fldAddressLine1, 
                        fldAddressLine2, 
                        fldCity, 
                        fldState, 
                        fldPincode, 
                        fldPhoneNumber
                    )VALUES (
                        <cfqueryparam value = '#arguments.userId#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.firstName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.lastName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.addressLine1#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.addressLine2#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.city#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.state#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.pincode#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.formStruct.phoneNumber#' cfsqltype = "varchar">
                    );
            </cfquery>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <cfset local.resultStruct["error"] = "Please enter all the Fields">
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction name = "deleteAddress" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument name = "addressId" type = "integer" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfquery name = "">
            UPDATE
                tblAddress
            SET
                fldActive = 0
            WHERE
                fldAddress_ID = <cfqueryparam value = '#arguments.addressId#' cfsqltype = "integer">
        </cfquery>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction name = "verifyCard" returntype = "struct" returnformat = "json" access = "remote">
        <cfargument name = "cardNumber" type = "numeric" required = "true">
        <cfargument name = "cardCVV" type = "numeric" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfset local.cardNumber = "1122334455667788">
        <cfset local.cardCVV = "123">
        <cfif arguments.cardNumber EQ local.cardNumber AND arguments.cardCVV EQ local.cardCVV>
            <cfset local.resultStruct["success"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction name = "placeOrder" returntype = "struct">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "orderAddressId" type = "integer" required = "true">
        <cfargument name = "cardNumber" type = "numeric" required = "true">
        <cfargument name = "cardCVV" type = "numeric" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfset local.verifyCardResult = verifyCard(cardNumber=arguments.cardNumber,cardCVV=arguments.cardCVV)>
        <cfif structKeyExists(local.verifyCardResult, "success")>
            <cfset local.UUID = createUUID()>
            <cfset local.cardLastFour = right(arguments.cardNumber, 4)>
            <cfquery name = "local.placeOrder">
                CALL placeOrder(
                    <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">,
                    <cfqueryparam value = "#arguments.orderAddressId#" cfSqlType = "integer">,
                    <cfqueryparam value = "#local.cardLastFour#" cfSqlType = "integer">,
                    <cfqueryparam value = "#local.UUID#" cfSqlType = "varchar">
                )
            </cfquery>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <cfset local.resultStruct["error"] = "Invalid Card Details">
        </cfif>
        <!--- Sending mail if order placed --->
        <cfif structKeyExists(local.resultStruct, "success")>
            <cfset local.userDetails = getProfileDetails(userId=arguments.userId)>
            <cfmail  
                from="abhijith1@gmail.com"  
                subject="Order placed"  
                to="#local.userDetails.email#"
                type="html"
            >
                <cfmailpart type="text/html">
                    <h3>Dear #local.userDetails.firstName#,</h3>
                    <p>Your order placed successfully.</p>
                    <p>Order ID : #local.UUID#</p>
                </cfmailpart>
            </cfmail>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction name = "getOrderHistory" returntype = "query">
        <cfargument name = "userId" type = "integer" required = "false">
        <cfargument name = "orderId" type = "string" required = "false">
        <cfquery name = "local.qryOrderHistory">
            SELECT 
                O.fldOrder_ID AS OrderID,
                O.fldTotalPrice AS totalPrice,
                O.fldTotalTax AS totalTax,
                O.fldOrderDate AS orderDate,
                OI.fldQuantity AS quantity,
                OI.fldUnitPrice AS unitPrice,
                OI.fldUnitTax AS unitTax,
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
            INNER JOIN tblBrands B ON B.fldBrand_ID = P.fldBrandId
            INNER JOIN tblProductImages PI ON PI.fldproductId = P.fldProduct_ID AND PI.fldDefaultImage = 1
            WHERE
                <cfif structKeyExists(arguments, "userId")>
                    O.fldUserId = <cfqueryparam value = "#arguments.userId#" cfSqlType = "integer">
                <cfelseif structKeyExists(arguments, "orderId")>
                    O.fldOrder_ID = <cfqueryparam value = "#arguments.orderId#" cfSqlType = "varchar">
                </cfif>
            ORDER BY
                O.fldOrderDate
        </cfquery>
        <cfreturn local.qryOrderHistory>
    </cffunction>

    <cffunction name = "downloadInvoice" returntype = "struct" returnformat = "json" access = "remote">
        <cfargument name = "orderId" type = "string" required = "true">
        <cfset local.resultStruct = structNew()>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>
</cfcomponent>