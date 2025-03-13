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
        <cfif listfirst(CGI.script_name,'/') EQ "admin">
            <cfset local.adminPublicPages = ["/admin/login.cfm"]>
            <cfif arrayFindNoCase(local.adminPublicPages, arguments.requestedPage) 
                OR (structKeyExists(session, "adminSession") AND structKeyExists(session.adminSession, "userId"))>
                <cfreturn true>
            <cfelse>
                <cflocation url="../admin/login.cfm" addtoken ="false"> 
            </cfif>
        <cfelse>
            <cfset local.userRestrictedPages = ["/orderPage.cfm","/cartPage.cfm","/profilePage.cfm","/orderHistory.cfm"]>
            <cfif arrayFindNoCase(local.userRestrictedPages, arguments.requestedPage) 
                AND NOT (structKeyExists(session, "userSession") AND structKeyExists(session.userSession, "userId"))
            >
                <cflocation url="/login.cfm" addtoken ="false">
            <cfelse>
                <cfreturn true>
            </cfif>
        </cfif>
    </cffunction>
</cfcomponent>