<cfcomponent>
    <!--- user signup --->
    <cffunction name = "userSignup" returntype = "struct">
        <cfargument name="firstName" type ="string" required = "true">
        <cfargument name="lastName" type ="string" required = "true">
        <cfargument name="emailId" type ="string" required = "true">
        <cfargument name="phoneNumber" type ="string" required = "true">
        <cfargument name="password" type ="string" required = "true">

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
            len(trim(arguments.password)) GTE 8
        >
            <!--- check whether the field are valid --->
            <cfif REFindNoCase("[^a-zA-Z0-9]",arguments.firstName)>
                <cfset local.structResult["error"] = "First name should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.lastName)>
                <cfset local.structResult["error"] = "Last name should not contain any special charector or whitespace">
            <cfelseif NOT isValid("email", arguments.emailId)>
                <cfset local.structResult["error"] = "Please enter a valid email">
            <cfelseif REFindNoCase("^(\+?[0-9-]{8,15})$",arguments.phoneNumber)>
                <cfset local.structResult["error"] = "Please enter a valid phone number">
            <cfelse>
                <cfquery name="local.isEmailExist">
                    SELECT
                        fldUser_ID
                    FROM
                        tbluser
                    WHERE 
                        fldemail = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
                        OR
                        fldPhone = <cfqueryparam value = "#arguments.phoneNumber#" cfSqlType= "varchar">
                </cfquery>

                <cfif local.isEmailExist.recordCount>
                    <cfset local.structResult["error"] = "Email or phone number already exists">
                <cfelse>
                    <cfset local.saltString = generateSecretKey("AES")>
                    <cfset local.hashedPassword = hash(arguments.password & local.saltString,'SHA-512', 'utf-8', 125)>
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
                    <cfset session.userSession.userId = local.signUpresult.generatedKey>
                    <cfset session.userSession.name = arguments.firstName>
                    <cfset session.userSession.roleId = 2>
                </cfif>
            </cfif>
        <cfelse>
            <cfif len(trim(arguments.password)) LT 8>
                <cfset local.structResult["error"] = "Password needs to be atleast 8 characters long">
            <cfelse>
                <cfset local.structResult["error"] = "Please fill all the fields">
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <!--- userlogin --->
    <cffunction name="userLogin" returntype="struct">
        <cfargument name="username" type = "string" required = "true">
        <cfargument name="password" type = "string" required = "true">

        <cfset local.structResult = structNew()>

        <cfif len(trim(arguments.username)) AND len(trim(arguments.password))>
            <cfquery name="local.userDetails">
                SELECT
                    fldUser_ID,
                    fldFirstName,
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
                    <cfset session.userSession.userId = local.userDetails.fldUser_ID>
                    <cfset session.userSession.roleId = 2>
                    <cfset session.userSession.name = local.userDetails.fldFirstName>
                    <cfquery name = "local.getCartCount">
                        SELECT 
                            COUNT(fldCart_ID) AS cartCount
                        FROM
                            tblCart
                        WHERE
                            fldUserId = <cfqueryparam value = "#session.userSession.userId#" cfSqlType = "integer">
                    </cfquery>
                    <cfset session.userSession.cartCount = local.getCartCount.cartCount>
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
    <cffunction name="logOut" returntype="struct" returnformat = "json" access="remote">
        <cfset structClear(session)>
        <cfset local.logOutResult["success"] = true>
        <cfreturn local.logOutResult>
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
    <cffunction name = "getAddressList" returntype = "array">
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

    <!--- Update profile details --->
    <cffunction name = "updateProfile" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument name = "userId" type = "integer" required = "true">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "emailId" type = "string" required = "true">
        <cfargument name = "phoneNumber" type = "string" required = "true">
        <cfset local.resultStruct = structNew()>

        <cfif 
            len(trim(arguments.firstName))
            AND 
            len(trim(arguments.lastName))
            AND 
            len(trim(arguments.emailId))
            AND
            len(trim(arguments.phoneNumber))
        >
            <!--- check whether the field are valid --->
            <cfif REFindNoCase("[^a-zA-Z0-9]",arguments.firstName)>
                <cfset local.structResult["error"] = "First name should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.lastName)>
                <cfset local.structResult["error"] = "Last name should not contain any special charector or whitespace">
            <cfelseif NOT isValid("email", arguments.emailId)>
                <cfset local.structResult["emailError"] = "Please enter a valid email">
            <cfelse>
                <cfif REFindNoCase("^(\+?[0-9-]{8,15})$",arguments.phoneNumber)>
                    <cfquery name="local.isEmailExist">
                        SELECT
                            fldEmail,fldPhone
                        FROM
                            tbluser
                        WHERE(
                            fldemail = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
                            OR
                            fldPhone = <cfqueryparam value = "#arguments.phoneNumber#" cfSqlType= "varchar">
                        )
                            AND
                            NOT fldUser_ID = <cfqueryparam value = "#arguments.userId#" cfSqlType= "varchar">;
                    </cfquery>

                    <cfif local.isEmailExist.recordCount>
                        <cfif local.isEmailExist.fldEmail EQ arguments.emailId>
                            <cfset local.structResult["emailError"] = "Email already exists">
                        </cfif>
                        <cfif local.isEmailExist.fldPhone EQ arguments.phoneNumber>
                            <cfset local.structResult["phoneError"] = "Phone number already exists">
                        </cfif>
                    <cfelse>
                        <cfquery result="local.signUpresult">
                            UPDATE
                                tbluser
                            SET
                                fldFirstName = <cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar">,
                                fldLastName = <cfqueryparam value = '#arguments.lastName#' cfsqltype = "varchar">,
                                fldPhone = <cfqueryparam value = '#arguments.phoneNumber#' cfsqltype = "varchar">,
                                fldEmail = <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">
                            WHERE 
                                flduser_ID = <cfqueryparam value = "#arguments.userId#" cfSqlType= "varchar">;
                        </cfquery>
                        <cfset local.structResult["success"] = true>
                        <cfset session.userSession.name = arguments.firstName>
                    </cfif>
                <cfelse>
                    <cfset local.structResult["phoneError"] = "Please enter a valid phone number">
                </cfif>
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please fill all the fields">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <!--- Add new address --->
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
            len(trim(arguments.formStruct.city))
            AND 
            len(trim(arguments.formStruct.state))
            AND 
            len(trim(arguments.formStruct.phoneNumber))
            AND 
            len(trim(arguments.formStruct.pincode))
        >
            <!--- check whether the field are valid --->
            <cfif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.firstName)>
                <cfset local.resultStruct["error"] = "First name should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.lastName)>
                <cfset local.resultStruct["error"] = "Last name should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.addressLine1)>
                <cfset local.resultStruct["error"] = "Address line 1 should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.addressLine2)>
                <cfset local.resultStruct["error"] = "Address line 2 should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.city)>
                <cfset local.resultStruct["error"] = "City should not contain any special charector or whitespace">
            <cfelseif REFindNoCase("[^a-zA-Z0-9]",arguments.formStruct.state)>
                <cfset local.resultStruct["error"] = "State should not contain any special charector or whitespace">
            <cfelseif NOT REFindNoCase("^(\+?[0-9-]{8,15})$",arguments.formStruct.phoneNumber)>
                <cfset local.resultStruct["error"] = "Please enter a valid phone number">
            <cfelseif NOT REFindNoCase("^[0-9]{6}$",arguments.formStruct.pincode)>
                <cfset local.resultStruct["error"] = "Please enter a valid pincode">
            <cfelse>
                <cfquery>
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
            </cfif>
        <cfelse>
            <cfset local.resultStruct["error"] = "Please enter all the Fields">
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Delete address --->
    <cffunction name = "deleteAddress" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument name = "addressId" type = "integer" required = "true">

        <cfset local.resultStruct = structNew()>
        <cfquery>
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
</cfcomponent>