<cfcomponent>
    <cffunction  name = "userSignp" returntype = "struct">
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
            len(trim(arguments.password))
        >
            <cfquery name="local.isEmailExist">
                SELECT
                    fldUser_ID
                FROM
                    tbluser
                WHERE 
                    fldemail = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
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
                        )
                    VALUES(
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
                WHERE
                    (
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
                <cfloop query="local.userDetails">
                    <cfif 
                        local.userDetails.fldHashedPassword
                        EQ
                        hash(arguments.password & local.userDetails.fldUserSaltString,'SHA-512', 'utf-8', 125)
                    >
                        <cfset session.userId = local.userDetails.fldUser_ID>
                        <cfset local.structResult["success"] = true>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif NOT structKeyExists(local.structResult, "success")>
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
    <cffunction  name="logOut" returntype="boolean" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>
</cfcomponent>