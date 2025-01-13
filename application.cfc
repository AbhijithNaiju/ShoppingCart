<cfcomponent>
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>

    <cffunction  name="onRequestStart"> 
        <cfargument  name="requestedPage">
        
        <cfset local.publicPages = ["/admin/login.cfm"]>
        <cfif arrayFindNoCase(local.publicPages, arguments.requestedPage) OR structKeyExists(session, "userId")>
            <cfreturn true>
        <cfelse>
            <cflocation url="../admin/login.cfm" addtoken ="false"> 
        </cfif>
    </cffunction>

    <cffunction  name="onMissingTemplate">
        <cfinclude template="missingPage.cfm">
        <cfreturn true>
    </cffunction>

</cfcomponent>