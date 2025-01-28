<cfcomponent>
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>

    <cffunction  name="onApplicationStart" returnType="boolean">
        <cfset application.adminObject = createObject("component","admin.components.admin")>
        <cfset application.userObject = createObject("component","components.user")>
        <cfreturn true>
    </cffunction>

    <cffunction  name="onRequestStart" returnType="boolean"> 
        <cfargument  name="requestedPage">

        <cfif structKeyExists(url, "reload") AND url.reload EQ "true">
            <cfset onApplicationStart()>
        </cfif>
        <cfif listfirst(CGI.script_name,'/') EQ "admin">
            <cfset local.adminPublicPages = ["/admin/login.cfm"]>
            <cfif arrayFindNoCase(local.adminPublicPages, arguments.requestedPage) OR structKeyExists(session, "userId")>
                <cfreturn true>
            <cfelse>
                <cflocation url="../admin/login.cfm" addtoken ="false"> 
            </cfif>
        <cfelse>
            <cfset local.userRestrictedPages = ["/orderPage.cfm","/cartPage.cfm"]>
            <cfif arrayFindNoCase(local.userRestrictedPages, arguments.requestedPage) AND NOT structKeyExists(session, "userId")>
                <cflocation url="/login.cfm" addtoken ="false"> 
            <cfelse>
                <cfreturn true>
            </cfif>
        </cfif>
    </cffunction>

    <cffunction  name="onMissingTemplate" returntype = "boolean">
        <cfinclude template="missingPage.cfm">
        <cfreturn true>
    </cffunction>

<!---    <cffunction  name="onError" returntype ="void"> 
        <cfargument name="exception" type="any" required=true>
        <cfargument name="eventName" type="String" required=true>

        <cfif NOT (arguments.eventName IS "onSessionEnd") OR (arguments.eventName IS "onApplicationEnd")>
            <cfmail  
                from="abhijith1@gmail.com"  
                subject="Error occured"  
                to="abc@gmail.com"
            >
                An unexpected error occurred.
                Please provide the following information to technical support:
                Error Event: #arguments.eventName#
                Error details: #arguments.exception#
            </cfmail>
            <cflocation  url="errorPage.cfm" addtoken="false">
        </cfif>
     </cffunction> --->

</cfcomponent>