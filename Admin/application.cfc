<cfcomponent>
    <cfset this.name = "shoppingCartAdmin">
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>
    <cfset this.sessiontimeout = CreateTimeSpan(0,1,0,0)>

    <cffunction name="onApplicationStart" returnType="boolean">
        <cfset application.adminObject = createObject("component","admin.components.admin")>
        <cfset application.adminProductObject = createObject("component","admin.components.product")>
        <cfset application.adminCategoryObject = createObject("component","admin.components.category")>
        <cfset application.adminSubcategoryObject = createObject("component","admin.components.subcategory")>
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean"> 
        <cfargument name="requestedPage">
        <cfif structKeyExists(url, "reload") AND url.reload EQ "true">
            <cfset onApplicationStart()>
        </cfif>
        <cfset local.adminPublicPages = ["/admin/login.cfm","/admin/components/admin.cfc"]>
        <cfif arrayFindNoCase(local.adminPublicPages, arguments.requestedPage) 
            OR (structKeyExists(session, "adminSession") AND structKeyExists(session.adminSession, "userId"))>
            <cfreturn true>
        <cfelse>
            <cflocation url="/admin/login.cfm" addtoken ="false"> 
        </cfif>
    </cffunction>

    <cffunction name="onMissingTemplate" returntype = "boolean">
        <cfinclude template="/missingPage.cfm">
        <cfreturn true>
    </cffunction>

    <!--- <cffunction name="onError" returntype ="void">
        <cfargument name="exception" type="any" required=true>
        <cfargument name="eventName" type="String" required=true>
        <cfif NOT (arguments.eventName IS "onSessionEnd") OR (arguments.eventName IS "onApplicationEnd")>
            <cfmail  
                from="abhijith1@gmail.com"  
                subject="Error occured"  
                to="abhijith@gmail.com"
            >
                <cfmailpart type="text/html">
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
            <cflocation url="/errorPage.cfm" addtoken="false">
        </cfif>
    </cffunction> --->
</cfcomponent>