<cfcomponent>
    <cffunction  name="adminLogin" returntype="struct">
        <cfargument  name="userName" required="true" type="string">
        <cfargument  name="password" required="true" type="string">

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
            <cfif 
                local.qryAdminData.fldHashedPassword 
                EQ
                Hash(arguments.password & local.qryAdminData.fldUserSaltString, 'SHA-512', 'utf-8', 125)
            >
                <cfset session.adminSession.userId = local.qryAdminData.fldUser_ID>
                <cflocation  url="./index.cfm" addtoken ="false">
            <cfelse>
                <cfset local.structResult["error"] = "Invalid username or password">
            </cfif>
        <cfelse>
            <cfset local.structResult["error"] = "Invalid username or password">
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="logOut" returntype="struct" returnformat = "json" access="remote">
        <cfif structKeyExists(session, "adminSession")>
            <cfset structClear(session.adminSession)>
        </cfif>
        <cfset local.resultStruct["success"] = true>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction  name="getCategories" returnType="query">
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

    <cffunction  name="editCategory" returntype="struct">
        <cfargument  name="categoryName" required = "true" type="string">
        <cfargument  name="categoryId" required = "true" type="integer">

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
            <cfif val(arguments.categoryId) GT 0>
                <cfquery name="local.categoryAdd">
                    UPDATE
                        tblCategory
                    SET
                        fldCategoryName = <cfqueryparam value = "#trim(arguments.categoryName)#" cfSqlType="varchar">,
                        fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
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
                        <cfqueryparam value = '#trim(arguments.categoryName)#' cfSqlType="varchar">,
                        <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                    )
                </cfquery>
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

    <cffunction  name="getSubCategories" returnType="array" access= "remote" returnFormat = "JSON">
        <cfargument  name="categoryId" required="true" type="integer">

        <cfset local.subcategoryStruct = structNew()>
        <cfquery name="local.subCategoryData" returntype="struct">
            SELECT
                SC.fldSubCategoryName AS subcategoryName,
                SC.fldSubCategory_ID AS subcategoryId,
                C.fldCategoryName AS categoryName
            FROM
                tblSubCategory SC
            INNER JOIN tblCategory C ON C.fldCategory_ID = SC.fldCategoryId AND C.fldActive = 1
            WHERE
                SC.fldCategoryId = <cfqueryparam value = "#arguments.categoryId#" cfSqlType = "integer">
                AND
                SC.fldActive = 1;
        </cfquery>
        <cfreturn local.subCategoryData.resultSet>
    </cffunction>

    <cffunction  name="editSubCategory" returntype="struct">
        <cfargument  name="categoryId" required = "true" type = "integer">
        <cfargument  name="subCategoryName" required ="true" type = "string">
        <cfargument  name="subCategoryId" requred = "true" type = "integer">

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
            <cfif  val(arguments.subCategoryId) GT 0>
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
            <cfelse>
                <cfquery name="local.categoryUpdate">
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
            </cfif>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="deleteSubCategory" access="remote" returnformat = "plain" returntype="boolean">
        <cfargument  name="subCategoryId" required = "true" type = "string">

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

    <cffunction  name="getProducts" returnType="query">
        <cfargument  name="subCategoryId" required="true" type = "integer">
        <cfquery name="local.productData">
            SELECT
                P.fldProductName,
                P.fldProduct_ID,
                P.fldBrandId,
                P.fldPrice,
                P.fldTax,
                B.fldBrandName,
                PI.fldImageFileName,
                SC.fldSubcategoryName subcategoryName,
                SC.fldCategoryId AS categoryId
            FROM
                tblProduct P
            INNER JOIN tblSubcategory SC ON SC.fldSubcategory_ID = P.fldsubcategoryId AND SC.fldActive = 1
            INNER JOIN tblCategory C ON C.fldCategory_ID = SC.fldCategoryId AND C.fldActive = 1
            INNER JOIN tblbrands B ON P.fldBrandId = B.fldBrand_ID AND B.fldActive = 1
            LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId AND PI.fldDefaultImage = 1
            WHERE
                P.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType = "integer">
                AND
                P.fldActive=1
        </cfquery>

        <cfreturn local.productData>
    </cffunction>
    <cffunction  name="getProductDetails" returnType="struct" returnFormat="JSON" access="remote">
        <cfargument  name="productId" required="true" type = "integer">

        <cfquery name="local.productData">
            SELECT
                P.fldProductName,
                P.fldDescription,
                P.fldBrandId,
                P.fldTax,
                P.fldPrice
            FROM
                tblProduct P
            WHERE
                P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
                AND
                P.fldActive = 1;
        </cfquery>
        <cfset local.resultStruct = structNew()>
        <cfset local.resultStruct["productName"] = local.productData.fldProductName>
        <cfset local.resultStruct["productDescription"] = local.productData.fldDescription>
        <cfset local.resultStruct["brandId"] = local.productData.fldBrandId>
        <cfset local.resultStruct["tax"] = local.productData.fldTax>
        <cfset local.resultStruct["price"] = local.productData.fldPrice>
        <cfreturn local.resultStruct>
    </cffunction>

    <cffunction  name="getCategoryData" returntype="query">
        <cfargument  name="subCategoryId" required="true" type = "integer">
        <cfquery name="local.categoryData">
            SELECT
                C.fldCategoryName AS categoryName,
                SC.fldCategoryID AS categoryId,
                SC.fldSubcategoryName AS subcategoryName
            FROM
                tblSubCategory SC
            LEFT JOIN tblCategory  C ON SC.fldCategoryId = C.fldCategory_ID
            WHERE
                SC.fldSubCategory_ID = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType = "integer">
        </cfquery>
        <cfreturn local.categoryData>
    </cffunction>
    
    <cffunction  name="getBrands" returntype="query">
        <cfquery name = "local.brandData">
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblBrands   
            WHERE
                fldActive = 1;
        </cfquery>
        <cfreturn local.brandData>
    </cffunction>

    <cffunction  name = "addOrEditProduct" access = "remote" returnformat = "JSON" returntype="struct">
        <cfargument  name = "formBrandId" required = "true" type = "integer">
        <cfargument  name = "formSubCategoryId" required = "true" type = "integer">
        <cfargument  name = "productDescription" required = "true" type = "string">
        <cfargument  name = "productName" required = "true" type = "string">
        <cfargument  name = "productPrice" required = "true" type = "float">
        <cfargument  name = "productTax" required = "true" type = "float">
        <cfargument  name = "productId" required = "false" type = "integer">

        <cfset local.structResult = structNew()>
        <cfset local.uploadLocation = "../../assets/productImages">
        <cfif NOT directoryExists(expandPath(local.uploadLocation))>
            <cfset directoryCreate(expandPath(local.uploadLocation))>
        </cfif>
        <cffile
            action="uploadall"
            destination = "#expandPath(local.uploadLocation)#"
            nameConflict="MakeUnique"
            result = "local.fileNames"
        >
        <cfquery name="local.isProductExist">
            SELECT
                fldProduct_ID
            FROM
                tblProduct
            WHERE
                fldProductName = <cfqueryparam value = "#trim(arguments.productName)#" cfSqlType = "varchar">
                AND
                fldSubCategoryId = <cfqueryparam value = "#arguments.formSubCategoryId#" cfSqlType = "integer">
                AND
                fldActive = 1;
        </cfquery>
        <cfif local.isProductExist.recordCount AND structKeyExists(arguments, "productId") AND local.isProductExist.fldProduct_ID NEQ arguments.productId>
            <cfset local.structResult["error"] = "Product name already exists">
        <cfelse>
            <cfif structKeyExists(arguments, "productId") AND val(arguments.productId) GT 0>
                <cfquery name="local.productUpdate">
                    UPDATE
                        tblProduct
                    SET
                        fldSubCategoryId = <cfqueryparam value='#arguments.formSubCategoryId#' cfsqltype="integer">,
                        fldProductName = <cfqueryparam value='#trim(arguments.productName)#' cfsqltype="varchar">,
                        fldBrandId = <cfqueryparam value='#arguments.formBrandId#' cfsqltype="integer">,
                        fldDescription = <cfqueryparam value='#arguments.productDescription#' cfsqltype="varchar">,
                        fldPrice = <cfqueryparam value='#arguments.productPrice#' cfsqltype="decimal" scale="2">,
                        fldTax = <cfqueryparam value='#arguments.productTax#' cfsqltype="decimal" scale="2">,
                        fldUpdatedBy = <cfqueryparam value='#session.adminSession.userId#' cfsqltype="integer">
                    WHERE 
                        fldProduct_ID = <cfqueryparam value='#arguments.productId#' cfsqltype="integer">
                </cfquery>
                <cfset local.defaultImage = 0>
                <cfset local.productid = arguments.productId>
            <cfelse>
                <cfquery result="local.productResult">
                    INSERT INTO
                        tblProduct
                    (
                        fldSubCategoryId,
                        fldProductName,
                        fldBrandId,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy
                    )
                    VALUES
                    (
                        <cfqueryparam value='#arguments.formSubCategoryId#' cfsqltype="integer">,
                        <cfqueryparam value='#trim(arguments.productName)#' cfsqltype="varchar">,
                        <cfqueryparam value='#arguments.formBrandId#' cfsqltype="integer">,
                        <cfqueryparam value='#arguments.productDescription#' cfsqltype="varchar">,
                        <cfqueryparam value='#arguments.productPrice#' cfsqltype="decimal" scale="2">,
                        <cfqueryparam value='#arguments.productTax#' cfsqltype="decimal" scale="2">,
                        <cfqueryparam value='#session.adminSession.userId#' cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.defaultImage = 1>
                <cfset local.productid = local.productResult.generatedkey>

            </cfif>
            <cfloop array="#local.fileNames#" item="local.fileArrayItem" >
                <cfquery>
                    INSERT INTO 
                        tblProductImages
                    (
                        fldProductId,
                        fldImageFileName,
                        fldDefaultImage,
                        fldCreatedBy
                    )
                    VALUES
                    (
                        <cfqueryparam value='#local.productid#' cfsqltype="integer">,
                        <cfqueryparam value='#local.fileArrayItem.serverfile#' cfsqltype="varchar">,
                        <cfqueryparam value='#local.defaultImage#' cfsqltype="varchar">,
                        <cfqueryparam value='#session.adminSession.userId#' cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.defaultImage = 0>
            </cfloop>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
    <cffunction  name = "deleteProduct" access = "remote" returntype = "boolean" returnformat = "plain">
        <cfargument  name = "productId" required = "true" type = "integer">

        <cfquery>
            UPDATE
                tblProduct
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>
    <cffunction  name = "deleteImage" access="remote" returntype="boolean" returnformat = "plain">
        <cfargument  name  ="imageId" required = "true" type = "integer">

        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfSqlType="integer">;
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name="setDefaultImage" access="remote" returntype="boolean" returnformat = "plain">
        <cfargument  name = "imageId" required = "true" type = "integer">
        <cfargument  name = "productId" required = "true" type = "integer">

        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 0,
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfSqlType="integer">
                AND fldDefaultImage =1;
        </cfquery>
        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 1,
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
            WHERE
                fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfSqlType="integer">;
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name = "getProductImages" returntype = "struct" access = "remote" returnformat="JSON">
        <cfargument  name="productId" required = "true" type = "integer">

        <cfset local.resultStruct = structNew("Ordered")>
        <cfquery name="local.ProductImages">
            SELECT
                fldProductImage_ID,
                fldImageFileName,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfloop query="local.ProductImages">
            <cfif local.ProductImages.fldDefaultImage EQ 1>    
                <cfset local.resultStruct["defaultImage"][local.ProductImages.fldProductImage_ID]=local.ProductImages.fldImageFileName>
            <cfelse>
                <cfset local.resultStruct["remainingImages"][local.ProductImages.fldProductImage_ID]=local.ProductImages.fldImageFileName>
            </cfif>
        </cfloop>
        <cfreturn local.resultStruct>
    </cffunction>
</cfcomponent>