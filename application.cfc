<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>

    <cffunction  name="onApplicationStart" returnType="boolean">
        <cfset application.adminObject = createObject("component","admin.components.admin")>
        <cfset application.userObject = createObject("component","components.user")>
        <cfreturn true>
    </cffunction>

    <cffunction name = "onSessionEnd" returntype = "">
        <cfargument name="SessionScope" required=true>
        <cfargument name="ApplicationScope" required=true>
        <cfdump  var="#arguments#">
    </cffunction>

    <cffunction  name="onRequestStart" returnType="boolean"> 
        <cfargument  name="requestedPage">
        <cfif structKeyExists(url, "reload") AND url.reload EQ "true">
            <cfset onApplicationStart()>
        </cfif>
        <cfif listfirst(CGI.script_name,'/') EQ "admin">
            <cfset local.adminPublicPages = ["/admin/login.cfm"]>
            <cfif arrayFindNoCase(local.adminPublicPages, arguments.requestedPage) 
                OR (structKeyExists(session, "userId") AND session.roleId EQ 1)>
                <cfreturn true>
            <cfelse>
                <cflocation url="../admin/login.cfm" addtoken ="false"> 
            </cfif>
        <cfelse>
            <cfset local.userRestrictedPages = ["/orderPage.cfm","/cartPage.cfm","/profilePage.cfm","/orderHistory.cfm"]>
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

    <cffunction  name="onError" returntype ="void"> 
        <cfargument name="exception" type="any" required=true>
        <cfargument name="eventName" type="String" required=true>
        <cfif NOT (arguments.eventName IS "onSessionEnd") OR (arguments.eventName IS "onApplicationEnd")>
            <cfmail  
                from="abhijith1@gmail.com"  
                subject="Error occured"  
                to="abhijith@gmail.com"
            >
                <cfmailpart  type="text/html">
                    <html>
                        <body>
                            <h2>An unexpected error occurred.</h2>
                            <div>
                                Please provide the following information to technical support:
                                <p>Error Event: #arguments.eventName#</p>
                                <h3>Error details:</h3>
                                <div>
                                    <p>Error message: #arguments.exception.message#</p>
                                    <p>Line: #arguments.exception.tagContext[1].Line#</p>
                                    <p>Template: #arguments.exception.tagContext[1].template#</p>
                                    <p>#arguments.exception.tagContext[1].raw_trace#</p>
                                </div>
                            </div>
                        </body>
                    </html>
                </cfmailpart>
            </cfmail>
            <cflocation  url="errorPage.cfm" addtoken="false">
        </cfif>
    </cffunction>

</cfcomponent>