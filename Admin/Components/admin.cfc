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
                        <cfqueryparam value = '#trim(arguments.categoryName)#' cfSqlType="varchar">,
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
                    VALUES
                    (
                        <cfqueryparam value = "#arguments.categoryId#" cfSqlType="varchar">,
                        <cfqueryparam value = '#trim(arguments.subCategoryName)#' cfSqlType="varchar">,
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
                tp.fldProductName,
                tp.fldProduct_ID,
                tp.fldBrandId,
                tp.fldPrice,
                tb.fldBrandName,
                tpi.fldImageFileName
            FROM
                tblProduct tp
            LEFT JOIN
                tblbrands tb
            ON
                tp.fldBrandId = tb.fldBrand_ID
            LEFT JOIN
                tblProductImages tpi
            ON
                tp.fldProduct_ID = tpi.fldProductId
            WHERE
                tp.fldSubCategoryId = <cfqueryparam value = "#arguments.subCategoryId#" cfSqlType = "integer">
                AND
                tpi.fldDefaultImage = 1
                AND
                tp.fldActive = 1;
        </cfquery>

        <cfreturn local.productData>
    </cffunction>
    <cffunction  name="getProductDetails" returType="struct" returnFormat="JSON" access="remote">
        <cfargument  name="productId" required="true">

        <cfquery name="local.productData">
            SELECT
                tp.fldProductName,
                tp.fldDescription,
                tp.fldBrandId,
                tp.fldTax,
                tp.fldPrice
            FROM
                tblProduct tp
            WHERE
                tp.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
                AND
                tp.fldActive = 1;
        </cfquery>
        <cfset local.resultStruct = structNew()>
        <cfset local.resultStruct["productName"] = local.productData.fldProductName>
        <cfset local.resultStruct["productDescription"] = local.productData.fldDescription>
        <cfset local.resultStruct["brandId"] = local.productData.fldBrandId>
        <cfset local.resultStruct["tax"] = local.productData.fldTax>
        <cfset local.resultStruct["price"] = local.productData.fldPrice>
        <cfreturn local.resultStruct>
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
    
    <cffunction  name="getBrands">
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

    <cffunction  name="addOrEditProduct" access = "remote" returnformat = "JSON" >
        <cfargument  name="formBrandId" required = "true">
        <cfargument  name="formSubCategoryId" required = "true">
        <cfargument  name="productDescription" required = "true">
        <cfargument  name="productImages" required = "true">
        <cfargument  name="productName" required = "true">
        <cfargument  name="productPrice" required = "true">
        <cfargument  name="productTax" required = "true">
        <cfargument  name="productId" required = "false">

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
                fldSubCategoryId = <cfqueryparam value = "#arguments.formSubCategoryId#" cfSqlType = "varchar">
                AND
                fldActive = 1;
        </cfquery>
        <cfif local.isProductExist.recordCount AND local.isProductExist.fldProduct_ID NEQ arguments.productId>
            <cfset local.structResult["error"] = "Product name already exists">
        <cfelse>
            <cfif arguments.productId>
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
                        fldUpdatedBy = <cfqueryparam value='#session.userId#' cfsqltype="integer">
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
                        <cfqueryparam value='#session.userId#' cfsqltype="integer">
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
                        <cfqueryparam value='#session.userId#' cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.defaultImage = 0>
            </cfloop>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>
    <cffunction  name="deleteProduct" access="remote">
        <cfargument  name="productId" required = "true">

        <cfquery>
            UPDATE
                tblProduct
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">,
                fldactive = 0
            WHERE
                fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType="integer">
        </cfquery>

        <cfreturn true>
    </cffunction>
    <cffunction  name="deleteImage" access="remote">
        <cfargument  name="imageId" required = "true">

        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">,
                fldactive = 0
            WHERE
                fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfSqlType="integer">;
        </cfquery>

        <cfreturn true>
    </cffunction>

    <cffunction  name="setDefaultImage" access="remote" returnformat = "plain">
        <cfargument  name="imageId" required = "true">
        <cfargument  name="productId" required = "true">

        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 0,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfSqlType="varchar">;
        </cfquery>
        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 1,
                fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfSqlType="varchar">
            WHERE
                fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfSqlType="varchar">;
        </cfquery>

        <cfreturn arguments.productId>
    </cffunction>

    <cffunction  name="getProductImages" returntype="struct" access="remote" returnformat="JSON">
        <cfargument  name="productId">

        <cfset local.resultStruct = structNew("Ordered")>
        <cfquery name="local.ProductImages">
            SELECT
                fldProductImage_ID,
                fldImageFileName,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="NUMERIC">
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