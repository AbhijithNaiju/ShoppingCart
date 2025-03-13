<cfcomponent>
    <!--- subcategory list --->
    <cffunction name = "getSubcategories" returntype = "query">
        <cfargument name = "categoryId" type = "integer" required = "false">
        <cfquery  name = "local.subcategories">
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
    <cffunction name = "getProductList" returntype = "struct" access = "remote" returnformat = "json">
        <cfargument  name = "subcategoryId" type = "integer" required = "false">
        <cfargument  name = "searchValue" type = "string" required = "false">
        <cfargument  name = "sortOrder" type = "string" required = "false">
        <cfargument  name = "minPrice" type = "float" required = "false">
        <cfargument  name = "maxPrice" type = "float" required = "false">
        <cfargument  name = "excludedIdList" type = "string" required = "false">
        <cfargument name = "count" type = "string" required = "false">
        <cfargument name = "limit" type = "integer" required = "false">

        <cfset local.resultStruct = structNew()>
        <cfquery  name = "local.getProducts" returntype="struct">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                (P.fldPrice*P.fldTax/100) AS productTax,
                P.fldSubcategoryId AS subCategoryId,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                SC.fldSubcategoryName AS subcategoryName
            FROM
                tblCategory C
            INNER JOIN tblSubcategory SC ON SC.fldCategoryId = C.fldCategory_ID AND SC.fldActive = 1
            INNER JOIN tblProduct P ON SC.fldSubcategory_ID = P.fldSubcategoryId AND P.fldActive = 1
            INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1 AND PI.fldActive = 1
            WHERE
                C.fldActive=1
                <cfif structKeyExists(arguments, "subcategoryId")>
                    AND
                    SC.fldSubcategory_ID = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "excludedIdList") AND len(arguments.excludedIdList)>
                    AND
                    P.fldProduct_ID NOT IN (<cfqueryparam value = "#arguments.excludedIdList#" list="true" cfSqlType = "integer">)
                </cfif>
                <cfif structKeyExists(arguments, "searchValue") AND len(arguments.searchValue)>
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
                    <cfif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "asc">
                        (P.fldPrice+P.fldTax) ASC
                    <cfelseif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "desc">
                        (P.fldPrice+P.fldTax) DESC
                    <cfelse>
                        RAND()
                    </cfif>
                <cfif structKeyExists(arguments, "limit")
                >
                    LIMIT <cfqueryparam value = "#arguments.limit#" cfSqlType = "integer">
                </cfif>
        </cfquery>
        <cfif structKeyExists(arguments, "count")>
            <cfquery name = "local.totalProducts">
                SELECT
                    COUNT(*) AS productCount
                FROM
                    tblProduct P
                INNER JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID AND SC.fldActive = 1
                INNER JOIN tblCategory C ON SC.fldCategoryId = C.fldCategory_ID AND C.fldActive = 1
                INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
                WHERE
                    P.fldActive=1
                    <cfif structKeyExists(arguments, "subcategoryId")>
                        AND
                        P.fldSubcategoryId = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "searchValue") AND len(arguments.searchValue)>
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
            </cfquery>
            <cfset local.resultStruct["productCount"] = local.totalProducts.productCount>
        </cfif>
        <cfset local.resultStruct["resultArray"] = local.getProducts.resultSet>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- get details of single product --->
    <cffunction name = "getProductDetails" returntype = "array">
        <cfargument  name = "productId" type = "integer" required = "true">
            <cfquery  name = "local.productDetails" returnType="struct">
                SELECT 
                    P.fldproductName AS productName,
                    P.fldDescription AS description,
                    P.fldPrice AS productPrice,
                    (P.fldPrice*P.fldTax/100) AS productTax,
                    B.fldBrandName AS brandName,
                    PI.fldImageFileName AS imageFileName,
                    PI.fldDefaultImage AS defaultImage,
                    P.fldSubcategoryId AS subCategoryId,
                    C.fldCategoryname AS categoryName,
                    C.fldCategory_ID AS categoryId,
                    SC.fldSubcategoryname AS SubcategoryName
                FROM
                    tblProduct P
                INNER JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID AND SC.fldActive = 1
                INNER JOIN tblCategory C ON SC.fldCategoryId = C.fldCategory_ID AND C.fldActive = 1
                INNER JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
                LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldActive=1
                WHERE
                    P.fldActive=1
                    AND
                    P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
            </cfquery>
        <cfreturn local.productDetails.resultSet>
    </cffunction>
</cfcomponent>