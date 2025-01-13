<cfcomponent>
    <cffunction  name="adminLogin">
        <cfargument  name="userName" required="true">
        <cfargument  name="password" required="true">

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

    <cffunction  name="editCategory">
        <cfargument  name="categoryName" required = "true">
        <cfargument  name="categoryId" required = "true">

        <cfset local.structResult = structNew()>
        
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
        <cfargument  name="categoryId" required = "true">

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

    <cffunction  name="getSubCategories" returType="query" access= "remote" returnFormat = "JSON">
        <cfargument  name="categoryId" required="true">

        <cfset local.subcategoryStruct = structNew()>
        <cfquery name="local.subCategoryData">
            SELECT
                fldSubCategoryName,
                fldSubCategory_ID
            FROM
                tblSubCategory
            WHERE
                fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                AND
                fldActive = 1;
        </cfquery>
        <cfloop query="local.subCategoryData">
            <cfset local.subcategoryStruct[local.subCategoryData.fldSubCategory_ID] = local.subCategoryData.fldSubCategoryName>
        </cfloop>
        <cfreturn local.subcategoryStruct>
    </cffunction>

    <cffunction  name="editSubCategory">
        <cfargument  name="categoryId" required ="true">
        <cfargument  name="subCategoryName" required ="true">
        <cfargument  name="subCategoryId" requred = "true">

        <cfset local.structResult = structNew()>
        
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
                <cfset local.structResult["error"] = "Category name #arguments.subCategoryName# already exists">
            </cfif>
        <cfelse>
            <cfif arguments.subCategoryId>
                <cfquery name="local.subCategoryAdd">
                    UPDATE
                        tblSubCategory
                    SET
                        fldcategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType="integer">,
                        fldSubCategoryName = <cfqueryparam value = "#trim(arguments.subCategoryName)#" cfSqlType="varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    WHERE
                        fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType="integer">;
                </cfquery>
            <cfelse>
                <cfquery name="local.categoryUpdate">
                    INSERT INTO
                        tblSubCategory
                    (
                        fldcategoryId,
                        fldSubCategoryName,
                        fldCreatedBy
                    )
                    VALUES(
                        <cfqueryparam value = "#arguments.categoryId#" cfSqlType="varchar">,
                        <cfqueryparam value = "#trim(arguments.subCategoryName)#" cfSqlType="varchar">,
                        <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
                    )
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="deleteSubCategory" access="remote" returnformat = "plain">
        <cfargument  name="subCategoryId" required = "true">

        <cfquery>
            UPDATE
                tblSubCategory
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">,
                fldactive = 0
            WHERE
                fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name="getProducts" returType="query">
        <cfargument  name="subCategoryId" required="true">

        <cfquery name="local.productData">
            SELECT
                fldProductName,
                fldProduct_ID
            FROM
                tblProduct
            WHERE
                fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType = "integer">
                AND
                fldActive = 1;
        </cfquery>

        <cfreturn local.productData>
    </cffunction>
    <cffunction  name="getCategoryData">
        <cfargument  name="subCategoryId" required="true">
        <cfquery name="local.categoryData">
            SELECT
                fldCategoryName,
                fldCategoryID
            FROM
                tblSubCategory tsc
            LEFT JOIN
                tblCategory  tc
            ON
                tsc.fldCategoryId = tc.fldCategory_ID
            WHERE
                tsc.fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType = "integer">
        </cfquery>
        <cfreturn local.categoryData>
    </cffunction>
</cfcomponent>