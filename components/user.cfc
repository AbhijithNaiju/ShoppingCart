<cfcomponent>
    <cffunction  name = "userSignp" returntype = "struct">
        <cfargument  name="firstName" type ="string" required = "true">
        <cfargument  name="lastName" type ="string" required = "true">
        <cfargument  name="emailId" type ="string" required = "true">
        <cfargument  name="phoneNumber" type ="string" required = "true">
        <cfargument  name="password" type ="string" required = "true">

        <cfset local.structResult = structNew()>

        <cfif 
            len(trim(arguments.firstName))
            AND 
            len(trim(arguments.lastName))
            AND 
            len(trim(arguments.emailId))
            AND 
            len(trim(arguments.phoneNumber))
            AND
            len(trim(arguments.password))
        >
            <cfquery name="local.isEmailExist">
                SELECT
                    fldUser_ID
                FROM
                    tbluser
                WHERE 
                    fldemail = <cfqueryparam value = "#arguments.emailId#" cfSqlType= "varchar">
            </cfquery>
            <cfif local.isEmailExist.recordCount>
                <cfset local.structResult["error"] = "Email already exists">
            <cfelse>
                <cfset local.saltString = generateSecretKey("AES")>
                <cfset local.hashedPassword =hash(arguments.password & local.saltString,'SHA-512', 'utf-8', 125)>
                <cfquery result="local.signUpresult">
                    INSERT INTO
                        tbluser(
                            fldFirstName,
                            fldLastName,
                            fldPhone,
                            fldEmail,
                            fldHashedPassword,
                            fldUserSaltString,
                            fldRoleId
                        )
                    VALUES(
                        <cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.lastName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.phoneNumber#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.emailId#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#local.hashedPassword#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#local.saltString#' cfsqltype = "varchar">,
                        2
                    );
                </cfquery>
                <cfset local.structResult["success"] = true>
                <cfset session.userId = local.signUpresult.generatedKey>
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please fill all the fields">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
    <cffunction  name="userLogin" returntype="struct">
        <cfargument  name="username" type = "string" required = "true">
        <cfargument  name="password" type = "string" required = "true">

        <cfset local.structResult = structNew()>

        <cfif len(trim(arguments.username)) AND len(trim(arguments.password))>
            <cfquery name="local.userDetails">
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
                    fldRoleId=2
                    AND
                    fldActive=1;
            </cfquery>
            <cfif local.userDetails.recordCount>
                <cfloop query="local.userDetails">
                    <cfif 
                        local.userDetails.fldHashedPassword
                        EQ
                        hash(arguments.password & local.userDetails.fldUserSaltString,'SHA-512', 'utf-8', 125)
                    >
                        <cfset session.userId = local.userDetails.fldUser_ID>
                        <cfset local.structResult["success"] = true>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif NOT structKeyExists(local.structResult, "success")>
                    <cfset local.structResult["error"] = "Invalid password">
                </cfif>
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Please enter username and password">
        </cfif>

        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="logOut" returntype="boolean" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <cffunction name = "getAllCategories" returntype = "query">
        <cfquery  name = "local.getAllCategories">
            SELECT 
                fldCategory_ID AS categoryId,
                fldCategoryName AS categoryName
            FROM
                tblCategory
            WHERE
                fldActive=1;
        </cfquery>
        <cfreturn local.getAllCategories>
    </cffunction>

    <cffunction name = "getAllSubcategories" returntype = "query">
        <cfargument  name = "categoryId" type = "integer" required = "false">
        <cfquery  name = "local.getAllSubcategories">
            SELECT 
                fldSubcategory_ID AS subcategoryId,
                fldSubcategoryName AS subcategoryName,
                fldCategoryId AS categoryId
            FROM
                tblSubCategory
            WHERE
                fldActive=1
            <cfif structKeyExists(arguments,"categoryId")>
                AND fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
            </cfif>
        </cfquery>
        <cfreturn local.getAllSubcategories>
    </cffunction>
    
    <cffunction name = "getRandomProducts" returntype = "query">
        <cfquery  name = "local.getRandomProducts">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                P.fldTax AS productTax,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                SC.fldsubCategoryName,
                SC.fldSubcategory_ID
            FROM
                tblProduct P
            LEFT JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1
            INNER JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID AND SC.fldActive = 1
            INNER JOIN tblCategory C ON SC.fldCategoryId = C.fldCategory_ID AND C.fldActive = 1
            WHERE
                P.fldActive=1
            ORDER BY RAND() 
            LIMIT 8
        </cfquery>
        <cfreturn local.getRandomProducts>
    </cffunction>

    <cffunction name = "getCategoryProducts" returntype = "query">
        <cfargument  name = "categoryId" type = "integer" required = "true">
        <cfquery  name = "local.getCategoryProducts">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                P.fldTax AS productTax,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                fldSubcategoryId AS subCategoryId
            FROM
                tblProduct P
            LEFT JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID
            INNER JOIN 
                    tblSubcategory SC 
                    ON 
                    P.fldSubcategoryId = SC.fldSubcategory_ID
                    AND
                    SC.fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                    AND
                    SC.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1
            WHERE
                P.fldActive=1
        </cfquery>
        <cfreturn local.getCategoryProducts>
    </cffunction>
    <cffunction name = "getSubcategoryProducts" returntype = "query">
        <cfargument  name = "subcategoryId" type = "integer" required = "true">
        <cfargument  name = "ascSort" type = "integer" required = "false">
        <cfargument  name = "descSort" type = "integer" required = "false">
        <cfquery  name = "local.getProducts">
            SELECT 
                P.fldProduct_ID AS productId,
                P.fldproductName AS productName,
                P.fldPrice AS productPrice,
                P.fldTax AS productTax,
                P.fldSubcategoryId AS subCategoryId,
                B.fldBrandName AS brandName,
                PI.fldImageFileName AS imageFileName,
                SC.fldSubcategoryName AS subcategoryName
            FROM
                tblProduct P
            LEFT JOIN tblBrands B ON P.fldBrandId = B.fldBrand_ID
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1
            LEFT JOIN tblSubcategory SC ON P.fldSubcategoryId = SC.fldSubcategory_ID
            WHERE
                P.fldActive=1
                AND
                P.fldSubcategoryId = <cfqueryparam value = "#arguments.subcategoryId#" cfSqlType = "integer">
            <cfif structKeyExists(arguments, "ascSort")>
                
            <cfelseif structKeyExists(arguments, "descSort")>

            </cfif>
        </cfquery>
        <cfreturn local.getProducts>
    </cffunction>
</cfcomponent>