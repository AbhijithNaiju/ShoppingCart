<cfcomponent>
    <cffunction  name="adminLogin">
        <cfargument  name="userName">
        <cfargument  name="password">

        <cfset local.structResult = structNew()>
<!---         ozOjU13Bkd44mGtwBhsv/w== --->
<!---         Hash(password & salt, 'SHA-512', 'utf-8', 125); --->
        <cfquery name="local.qryAdminData">
            SELECT
                fldUser_ID,
                fldHashedPassword,
                fldUserSaltString
            FROM
                tblUser
            WHERE
                (fldPhone = <cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar">
                OR
                fldEmail = <cfqueryparam value = '#arguments.userName#' cfsqltype = "cf_sql_varchar">)
                AND 
                fldRoleId = <cfqueryparam value =1 cfsqltype = "cf_sql_integer">
                AND
                fldActive = <cfqueryparam value =1 cfsqltype = "cf_sql_integer">;
        </cfquery>
        <cfif local.qryAdminData.recordCount>
            <cfif local.qryAdminData.fldHashedPassword 
                    EQ
                    Hash(arguments.password & local.qryAdminData.fldUserSaltString, 'SHA-512', 'utf-8', 125)>
                <cfset session.userId = local.qryAdminData.fldUser_ID>
                <cflocation  url="./index.cfm" addtoken ="false">
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username or password">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Invalid username or password">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
    <cffunction  name="logOut"  access="remote">

        <cfset structClear(session)>

        <cfreturn true>
    </cffunction>
</cfcomponent>