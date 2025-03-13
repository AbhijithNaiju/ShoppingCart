<cfcomponent>
    <cffunction name="getSubcategories" returnType="array" access= "remote" returnFormat = "JSON">
        <cfargument name="categoryId" type="integer" required="false">
        <cfargument name = "subcategoryId" type = "integer" required = "false">

        <cfset local.subcategoryStruct = structNew()>
        <cfquery name="local.subCategoryData" returntype="struct">
            SELECT
                SC.fldSubCategoryName AS subcategoryName,
                SC.fldSubCategory_ID AS subcategoryId,
                SC.fldCategoryID AS categoryId,
                C.fldCategoryName AS categoryName
            FROM
                tblSubCategory SC
            INNER JOIN tblCategory C ON C.fldCategory_ID = SC.fldCategoryId AND C.fldActive = 1
            WHERE
                SC.fldActive = 1
                <cfif structKeyExists(arguments, "categoryId")>
                AND
                    SC.fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "subcategoryID")>
                AND
                    SC.fldSubCategory_ID = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.subCategoryData.resultSet>
    </cffunction>

    <cffunction name="editSubCategory" returntype="struct" access = "remote" returnformat = "JSON">
        <cfargument name="categoryId" required = "true" type = "integer">
        <cfargument name="subCategoryName" required ="true" type = "string">
        <cfargument name="subCategoryId" requred = "true" type = "integer">

        <cfset local.structResult = structNew()>

        <cfif LEN(trim(arguments.subcategoryName)) EQ 0>
            <cfset local.structResult["error"] = "Please enter a name">
        <cfelseif REFindNoCase("[^a-zA-Z0-9\s]",arguments.subCategoryName)>
            <cfset local.structResult["error"] = "Subcategory name should not contain any special character">
        <cfelse>
            <cfquery name = "local.checkExistResult">
                SELECT
                    fldSubCategory_ID
                FROM
                    tblSubCategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value="#trim(arguments.subCategoryName)#" cfSqlType="varchar">
                    AND
                    fldcategoryId = <cfqueryparam value="#arguments.categoryId#" cfSqlType="integer">
                    AND
                    fldActive = 1;
            </cfquery>

            <cfif local.checkExistResult.recordCount>
                <cfif local.checkExistResult.fldSubCategory_ID EQ arguments.subCategoryId>
                    <cfset local.structResult["success"] = true>
                <cfelse>
                    <cfset local.structResult["error"] = "Category name already exists">
                </cfif>
            <cfelse>
                <cfif val(arguments.subCategoryId) GT 0>
                    <cfquery name="local.subCategoryAdd">
                        UPDATE
                            tblSubCategory
                        SET
                            fldcategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">,
                            fldSubCategoryName = <cfqueryparam value = "#trim(arguments.subCategoryName)#" cfSqlType="varchar">,
                            fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                        WHERE
                            fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType="integer">;
                    </cfquery>
                    <cfset local.structResult["edit"] = true>
                    <cfset local.structResult["subcategoryId"] = arguments.subCategoryId>
                <cfelse>
                    <cfquery result="local.categoryUpdate">
                        INSERT INTO
                            tblSubCategory
                        (
                            fldcategoryId,
                            fldSubCategoryName,
                            fldCreatedBy
                        )
                        VALUES
                        (
                            <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">,
                            <cfqueryparam value = '#trim(arguments.subCategoryName)#' cfSqlType="varchar">,
                            <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                        )
                    </cfquery>
                    <cfset local.structResult["subcategoryId"] = local.categoryUpdate.generatedKey>
                    <cfset local.structResult["create"] = true>
                </cfif>
                <cfset local.structResult["success"] = true>
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction name="deleteSubCategory" access="remote" returnformat = "plain" returntype="boolean">
        <cfargument name="subCategoryId" required = "true" type = "string">

        <cfquery>
            UPDATE
                tblSubCategory
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>
</cfcomponent>