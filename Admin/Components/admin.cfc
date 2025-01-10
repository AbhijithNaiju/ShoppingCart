<cfcomponent>
    <cffunction  name="adminLogin">
        <cfargument  name="userName">
        <cfargument  name="password">

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
            <cfif local.qryAdminData.fldHashedPassword 
                    EQ
                    Hash(arguments.password & local.qryAdminData.fldUserSaltString, 'SHA-512', 'utf-8', 125)>
                <cfset session.userId = local.qryAdminData.fldUser_ID>
                <cflocation  url="./index.cfm" addtoken ="false">
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username or password">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Invalid username or password">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
    <cffunction  name="logOut"  access="remote">

        <cfset structClear(session)>

        <cfreturn true>
    </cffunction>

    <cffunction  name="getCategories" returType="query">
        <cfquery name="local.categoryData">
            SELECT
                fldCategoryName,
                fldCategory_ID
            FROM
                tblCategory
            WHERE
                fldActive = 1;
        </cfquery>
        <cfreturn local.categoryData>
    </cffunction>

    <cffunction  name="getSubCategories" returType="query">
        <cfargument  name="categoryId">
        <cfquery name="local.subCategoryData">
            SELECT
                fldCategoryName,
                fldSubCategoryName,
                fldSubCategory_ID
            FROM
                tblSubCategory sc
            RIGHT JOIN
                tblCategory c
            ON
                sc.fldCategoryId = c.fldCategory_ID
            WHERE

                AND
                sc.fldActive = 1;
        </cfquery>
        <cfreturn local.subCategoryData>
    </cffunction>

    <cffunction  name="isValueExist">
        <cfargument  name="searchTable">
        <cfargument  name="searchItem">
        <cfargument  name="searchValue">

        <cfquery name = "local.qryCheckItemExist">
            SELECT
                *
            FROM
                #arguments.searchTable#
            WHERE
                #arguments.searchItem# = <cfqueryparam value="#arguments.searchValue#" cfSqlType="varchar">
                AND
                fldActive = 1;
        </cfquery>

        <cfreturn local.qryCheckItemExist>
    </cffunction>

    <cffunction  name="editCategory">
        <cfargument  name="categoryName">
        <cfargument  name="categoryId">

        <cfset local.structResult = structNew()>
        
        <cfset local.checkExistResult = isValueExist(
                                                    searchTable = "tblCategory",
                                                    searchItem = "fldCategoryName",
                                                    searchValue = trim(arguments.categoryName)
                                                    )>
        <cfif local.checkExistResult.fldCategory_ID EQ trim(arguments.categoryName)>
            <cfset local.structResult["success"] = true>
        <cfelseif local.checkExistResult.recordCount>
            <cfset local.structResult["error"] = "Category name #arguments.categoryName# already exists">
        <cfelse>
            <cfif arguments.categoryId>
                <cfquery name="local.categoryAdd">
                    UPDATE
                        tblCategory
                    SET
                        fldCategoryName = <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    WHERE
                        fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">
                </cfquery>
            <cfelse>
                <cfquery name="local.categoryUpdate">
                    INSERT INTO
                        tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                    VALUES(
                        <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                        <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="deleteCategory" access="remote" returnformat = "plain">
        <cfargument  name="categoryId">

        <cfquery>
            UPDATE
                tblCategory
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">,
                fldactive = 0
            WHERE
                fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>

        <cffunction  name="editSubCategory">
        <cfargument  name="categoryName">
        <cfargument  name="categoryId">

        <cfset local.structResult = structNew()>
        
        <cfset local.checkExistResult = isValueExist(
                                                    searchTable = "tblCategory",
                                                    searchItem = "fldCategoryName",
                                                    searchValue = trim(arguments.categoryName)
                                                    )>
        <cfif local.checkExistResult.fldCategory_ID EQ trim(arguments.categoryName)>
            <cfset local.structResult["success"] = true>
        <cfelseif local.checkExistResult.recordCount>
            <cfset local.structResult["error"] = "Category name #arguments.categoryName# already exists">
        <cfelse>
            <cfif arguments.categoryId>
                <cfquery name="local.categoryAdd">
                    UPDATE
                        tblCategory
                    SET
                        fldCategoryName = <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    WHERE
                        fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">
                </cfquery>
            <cfelse>
                <cfquery name="local.categoryUpdate">
                    INSERT INTO
                        tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                    VALUES(
                        <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                        <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
</cfcomponent>