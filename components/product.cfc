<cfcomponent>
    <!--- subcategory list --->
    <cffunction name = "getSubcategories" returntype = "query">
        <cfargument name = "categoryId" type = "string" required = "false">
        <cfquery name = "local.subcategories">
            SELECT 
                SC.fldSubcategory_ID AS subcategoryId,
                SC.fldSubcategoryName AS subcategoryName,
                C.fldCategory_ID AS categoryId,
                C.fldCategoryName AS categoryName
            FROM
                tblCategory C
            INNER JOIN tblSubCategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            WHERE
                C.fldActive=1
                <cfif structKeyExists(arguments, "categoryId")>
                    AND
                    C.fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                </cfif>
            ORDER BY
                C.fldCategory_id
        </cfquery>
        <cfreturn local.subcategories>
    </cffunction>

    <!--- get list of products --->
    <cffunction name = "getProductList" returntype = "struct">
        <cfargument name = "searchValue" type = "string" required = "false">
        <cfargument name = "subcategoryId" type = "string" required = "false">
        <cfargument name = "productId" type = "integer" required = "false">
        <cfargument name = "sortOrder" type = "string" required = "false">
        <cfargument name = "minPrice" type = "float" required = "false">
        <cfargument name = "maxPrice" type = "float" required = "false">
        <cfargument name = "offset" type = "integer" required = "false">
        <cfargument name = "limit" type = "integer" required = "false">
        
        <cfset local.resultStruct = structNew()>
        <cfquery name = "local.getProducts" returntype="struct">
            SELECT 
                P.fldproductName AS productName,
                <cfif structKeyExists(arguments,"productId")>
                    P.fldDescription AS description,
                    PI.fldDefaultImage AS defaultImage,
                    C.fldCategoryname AS categoryName,
                </cfif>
                C.fldCategory_ID AS categoryId,
                P.fldProduct_ID AS productId,
                P.fldPrice AS productPrice,
                (P.fldPrice*P.fldTax/100) AS productTax,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                P.fldSubcategoryId AS subCategoryId,
                SC.fldSubcategoryname AS SubcategoryName,
                COUNT(*) OVER() AS totalCount
            FROM
                tblCategory C
            INNER JOIN tblSubcategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            INNER JOIN tblProduct P ON SC.fldSubcategory_ID = P.fldSubcategoryId AND P.fldActive = 1
            INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldActive = 1
            <cfif NOT structKeyExists(arguments,"productId")>
                AND
                PI.fldDefaultImage = 1 
            </cfif>
            WHERE
                C.fldActive=1
                <cfif structKeyExists(arguments,"productId")>
                    <!--- If product id is present --->
                    AND
                    P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "subcategoryId") AND val(arguments.subcategoryId)>
                    AND
                    SC.fldSubcategory_ID = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "searchValue") AND len(trim(arguments.searchValue))>
                    AND(
                        P.fldProductName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                        OR
                        P.fldDescription LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                        OR
                        B.fldBrandName LIKE <cfqueryparam value = "%#arguments.searchValue#%" cfSqlType = "varchar">
                    )
                </cfif>
                <cfif structKeyExists(arguments, "minPrice") AND val(arguments.minPrice) GTE 0>
                    AND
                    (P.fldPrice+P.fldTax) >= <cfqueryparam value = '#val(arguments.minPrice)#' cfSqlType = "decimal" scale="2">
                </cfif>
                <cfif structKeyExists(arguments, "maxPrice") AND val(arguments.maxPrice) GTE 0>
                    AND
                    (P.fldPrice+P.fldTax) <= <cfqueryparam value = '#val(arguments.maxPrice)#' cfSqlType = "decimal" scale="2">
                </cfif>
                ORDER BY
                    <cfif structKeyExists(arguments,"productId")>
                        PI.fldDefaultImage DESC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "asc">
                        (P.fldPrice+P.fldTax) ASC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "desc">
                        (P.fldPrice+P.fldTax) DESC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "name">
                        P.fldProductName
                    <cfelse>
                        RAND()
                    </cfif>
                <cfif structKeyExists(arguments, "limit")
                >
                    LIMIT 
                    <cfif structKeyExists(arguments, "offset")
                    >
                        <cfqueryparam value = "#arguments.offset#" cfSqlType = "integer">,
                    </cfif>
                    <cfqueryparam value = "#arguments.limit#" cfSqlType = "integer">
                </cfif>
        </cfquery>
        <cfloop array="#local.getProducts.resultSet#" item="local.arrayItem">
            <cfset local.arrayItem.productId=application.userObject.encryptId(local.arrayItem.productId)>
            <cfset local.arrayItem.subCategoryId=application.userObject.encryptId(local.arrayItem.subCategoryId)>
            <cfset local.arrayItem.categoryId=application.userObject.encryptId(local.arrayItem.categoryId)>
        </cfloop>
        <cfset local.resultStruct["resultArray"] = local.getProducts.resultSet>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>
    <cffunction name = "getProductListRemote" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument name = "searchValue" type = "string" required = "false">
        <cfargument name = "encryptedSubcategoryId" type = "string" required = "false">
        <cfargument name = "sortOrder" type = "string" required = "false">
        <cfargument name = "minPrice" type = "float" required = "false">
        <cfargument name = "maxPrice" type = "float" required = "false">
        <cfargument name = "offset" type = "integer" required = "false">
        <cfargument name = "limit" type = "integer" required = "false">

        <cfif structKeyExists(arguments, "encryptedSubcategoryId") AND len(arguments.encryptedSubcategoryId)>
            <cfset local.decryptedSubcategoryId = application.userObject.decryptId(arguments.encryptedSubcategoryId)>
        <cfelse>
            <cfset local.decryptedSubcategoryId = 0>
        </cfif>

        <cfset local.resultStruct = getProductList(
            searchValue=arguments.searchValue,
            subcategoryId=local.decryptedSubcategoryId,
            sortOrder=arguments.sortOrder,
            limit=arguments.limit,
            offset=arguments.offset,
            minPrice=arguments.minPrice,
            maxPrice=arguments.maxPrice
        )>
        <cfreturn local.resultStruct>
    </cffunction>
</cfcomponent>