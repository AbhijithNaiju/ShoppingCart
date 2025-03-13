<cfcomponent>
    <cffunction name="adminLogin" returntype="struct">
        <cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">

        <cfset local.structResult = structNew()>
        <cfquery name="local.qryAdminData">
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
                fldRoleId=1
                AND
                fldActive=1;
        </cfquery>
        <cfif local.qryAdminData.recordCount>
            <cfif 
                local.qryAdminData.fldHashedPassword 
                EQ
                Hash(arguments.password & local.qryAdminData.fldUserSaltString, 'SHA-512', 'utf-8', 125)
            >
                <cfset session.adminSession.userId = local.qryAdminData.fldUser_ID>
                <cflocation url="./index.cfm" addtoken ="false">
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username or password">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Invalid username or password">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction name="logOut" returntype="struct" returnformat = "json" access="remote">
        <cfset structClear(session)>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>
</cfcomponent>