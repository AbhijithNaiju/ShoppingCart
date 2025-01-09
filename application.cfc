<cfcomponent>
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>

    <cffunction  name="onRequestStart">
        <cfargument  name="requestedPage">
        
        <cfset local.allowedPages = ["/ShoppingCart/Admin/login.cfm"]>
        <cfif NOT arrayFindNoCase(local.allowedPages, arguments.requestedPage) AND NOT structKeyExists(session, "userId")>
            <cflocation url="/ShoppingCart/Admin/login.cfm" addtoken ="false">
        </cfif>
    </cffunction>

</cfcomponent>