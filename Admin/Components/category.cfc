<cfcomponent>
        <cffunction  name="getCategories" returnType="query">
        <cfargument name = "categoryId" type = "integer" required = "false">
        <cfquery name="local.categoryData">
            SELECT
                fldCategoryName,
                fldCategory_ID
            FROM
                tblCategory
            WHERE
                fldActive = 1
                <cfif structKeyExists(arguments, "categoryId")>
                    AND
                    fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.categoryData>
    </cffunction>

    <cffunction  name="getCategoryname" access = "remote" returnformat = "json" returnType="struct">
        <cfargument name = "categoryId" type = "integer" required = "true">
        <cfset local.resultStruct = {}>
        <cfset local.categoryData = getCategories(arguments.categoryId)>
        <cfif local.categoryData.recordCount EQ 1>
            <cfset local.resultStruct["categoryName"] = local.categoryData.fldCategoryName>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <cfset local.resultStruct["error"] = "Category not found please try again">
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction  name="editCategory" access="remote" returntype="struct" returnformat = "JSON">
        <cfargument  name="categoryName" required = "true" type="string">
        <cfargument  name="categoryId" required = "true" type="integer">

        <cfset local.structResult = structNew()>
        <cfif LEN(trim(arguments.categoryName)) EQ 0>
            <cfset local.structResult["error"] = "Please enter a name">
        <cfelseif REFindNoCase("[^a-zA-Z0-9\s]",arguments.categoryName)>
            <cfset local.structResult["error"] = "Category name should not contain any special character">
        <cfelse>
            <cfquery name = "local.checkExistResult">
                SELECT
                    fldCategory_ID
                FROM
                    tblCategory
                WHERE
                    fldCategoryName = <cfqueryparam value="#trim(arguments.categoryName)#" cfSqlType="varchar">
                    AND
                    fldActive = 1;
            </cfquery>

            <cfif local.checkExistResult.recordCount>
                <cfif local.checkExistResult.fldCategory_ID EQ arguments.categoryId>
                    <cfset local.structResult["success"] = true>
                <cfelse>
                    <cfset local.structResult["error"] = "Category name #arguments.categoryName# already exists">
                </cfif>
            <cfelse>
                <cfif val(arguments.categoryId) GT 0>
                    <cfquery name="local.categoryUpdate">
                        UPDATE
                            tblCategory
                        SET
                            fldCategoryName = <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                            fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                        WHERE
                            fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">
                    </cfquery>
                    <cfset local.structResult["edit"] = true>
                <cfelse>
                    <cfquery result="local.categoryAdd">
                        INSERT INTO
                            tblCategory
                        (
                            fldCategoryName,
                            fldCreatedBy
                        )
                        VALUES(
                            <cfqueryparam value = '#trim(arguments.categoryName)#' cfSqlType="varchar">,
                            <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                        )
                    </cfquery>
                    <cfset local.structResult["create"] = true>
                    <cfset local.structResult["categoryId"] = local.categoryAdd.generatedKey>
                </cfif>
                <cfset local.structResult["success"] = true>
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returntype="boolean" returnformat="plain">
        <cfargument  name="categoryId" required = "true" type="integer">

        <cfquery>
            UPDATE
                tblCategory
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>
</cfcomponent>