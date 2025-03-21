<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.dataSource = "shoppingSiteDS">
    <cfset this.sessionManagement = true>
    <cfset this.sessiontimeout = CreateTimeSpan(0,1,0,0)>

    <cffunction name="onApplicationStart" returnType="boolean">
        <cfset application.secretKey = "p085TCupwllF2ks0JiBD3Q==">
        
        <cfset application.adminObject = createObject("component","admin.components.admin")>
        <cfset application.adminProductObject = createObject("component","admin.components.product")>
        <cfset application.adminCategoryObject = createObject("component","admin.components.category")>
        <cfset application.adminSubcategoryObject = createObject("component","admin.components.subcategory")>
        
        <cfset application.userObject = createObject("component","components.user")>
        <cfset application.productObject = createObject("component","components.product")>
        <cfset application.cartObject = createObject("component","components.cart")>
        <cfset application.orderObject = createObject("component","components.order")>
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="boolean"> 
        <cfargument name="requestedPage">
        <cfif structKeyExists(url, "reload") AND url.reload EQ "true">
            <cfset onApplicationStart()>
        </cfif>
        <cfset local.userRestrictedPages = ["/orderPage.cfm","/cartPage.cfm","/profilePage.cfm","/orderHistory.cfm","/orderInvoice.cfm"]>
        <cfif arrayFindNoCase(local.userRestrictedPages, arguments.requestedPage) 
            AND NOT (structKeyExists(session, "userSession") AND structKeyExists(session.userSession, "userId"))
        >
            <cflocation url="/login.cfm" addtoken ="false">
        <cfelse>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction name="onMissingTemplate" returntype = "boolean">
        <cfinclude template="missingPage.cfm">
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