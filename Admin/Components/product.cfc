<cfcomponent>
    <!--- Get list of products in a subcategory --->
    <cffunction name="getProducts" returnType="query">
        <cfargument name="subCategoryId" required="true" type = "integer">
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

    <!--- Get details of single product --->
    <cffunction name="getProductDetails" returnType="struct" returnFormat="JSON" access="remote">
        <cfargument name="productId" required="true" type = "integer">

        <cfquery name="local.productData" returntype = "struct">
            SELECT
                P.fldProductName AS productName,
                P.fldDescription AS productDescription,
                P.fldBrandId AS brandId,
                P.fldTax AS tax,
                P.fldPrice AS price,
                PI.fldProductImage_ID AS imageId,
                PI.fldImageFileName AS imageFileName,
                PI.fldDefaultImage AS isDefaultImage
            FROM
                tblProduct P
            INNER JOIN tblProductImages PI ON PI.fldProductId = P.fldProduct_ID AND PI.fldActive=1
            WHERE
                P.fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType = "integer">
                AND
                P.fldActive = 1
            ORDER BY PI.fldDefaultImage DESC;
        </cfquery>
        <cfset local.resultStruct = {}>
        <cfset local.resultStruct["imageList"] = []>
        <cfif local.productData.recordCount>
            <cfset local.resultStruct["productDetails"]["productName"] = local.productData.resultSet[1].productName>
            <cfset local.resultStruct["productDetails"]["productDescription"] = local.productData.resultSet[1].productDescription>
            <cfset local.resultStruct["productDetails"]["brandId"] = local.productData.resultSet[1].brandId>
            <cfset local.resultStruct["productDetails"]["tax"] = local.productData.resultSet[1].tax>
            <cfset local.resultStruct["productDetails"]["price"] = local.productData.resultSet[1].price>
            <cfloop array="#local.productData.resultSet#" item="local.imageItem">
                <cfset local.structImageDetails = {
                    "imageId":local.imageItem.imageId,
                    "imageFileName":local.imageItem.imageFileName,
                    "isDefaultImage":local.imageItem.isDefaultImage
                }>
                <cfset arrayAppend(local.resultStruct["imageList"], local.structImageDetails)>
            </cfloop>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <cfset local.resultStruct["error"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>
    
    <!--- Get details of brand --->
    <cffunction name="getBrands" returntype="query">
        <cfargument name = "brandId" type = "integer" required = "false">
        <cfquery name = "local.brandData">
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblBrands   
            WHERE
                fldActive = 1
                <cfif structKeyExists(arguments, "brandId")>
                    AND
                    fldBrand_ID = <cfqueryparam value="#arguments.brandId#" CFSQLType="integer">
                </cfif>
        </cfquery>
        <cfreturn local.brandData>
    </cffunction>

    <cffunction name = "addOrEditProduct" access = "remote" returnformat = "JSON" returntype="struct">
        <cfargument name = "formBrandId" required = "true" type = "integer">
        <cfargument name = "formSubCategoryId" required = "true" type = "integer">
        <cfargument name = "currentSubcategoryID" required = "true" type = "integer">
        <cfargument name = "formCategoryId" required = "true" type = "integer">
        <cfargument name = "productDescription" required = "true" type = "string">
        <cfargument name = "productName" required = "true" type = "string">
        <cfargument name = "productPrice" required = "true" type = "float">
        <cfargument name = "productTax" required = "true" type = "float">
        <cfargument name = "productImages" required = "false" type = "string">
        <cfargument name = "productId" required = "false" type = "integer">
        <cfargument name = "defaultImage" required = "true" type = "string">
        <cfargument name = "deletedProducts" required = "false" type = "string">

        <cfset local.structResult = structNew()>
        <cfset local.uploadLocation = "../../assets/productImages">
        <cfif NOT directoryExists(expandPath(local.uploadLocation))>
            <cfset directoryCreate(expandPath(local.uploadLocation))>
        </cfif>
        <cfset local.isError = false>
        <cfif LEN(trim(arguments.productName)) EQ 0>
            <cfset local.structResult["productNameError"] = "Please enter a name">
            <cfset local.isError = true>
        </cfif>

        <cfif REFindNoCase("[^a-zA-Z0-9.\s&/()%-+,\[\]\*\$]",arguments.productName)>
            <cfset local.structResult["productNameError"] = "Product name should not contain any special character">
            <cfset local.isError = true>
        </cfif>

        <cfif arguments.productTax GT 100>
            <cfset local.structResult["productTaxError"] = "Please enter valid tax percentage">
            <cfset local.isError = true>
        </cfif>

        <cfif local.isError EQ false>
            <!--- Uploading the file to product images folder --->
            <cftry>
                <cffile
                    action = "uploadall"
                    destination = "#expandPath(local.uploadLocation)#"
                    nameConflict = "MakeUnique"
                    result = "local.fileNames"
                    accept = "image/*"
                >
            <cfcatch>
                <cfset local.structResult["imageError"] = "Please enter valid image files">
                <cfset local.isError = true>
            </cfcatch>
            </cftry>
            <cfif structKeyExists(arguments, "productId") 
                AND val(arguments.productId) EQ 0
                AND arrayLen(local.Filenames) EQ 0
            >
                <!--- Added product does not conatin any images --->
                <cfset local.structResult["imageError"] = "Please enter images for the product">
                <cfset local.isError = true>
            </cfif>
        </cfif>
        <cfif local.isError EQ false>
            <!--- Getting products with same name --->
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
                <!--- Same name exists for another product --->
                <cfset local.structResult["productNameError"] = "Product name already exists">
                <cfset local.isError = true>
            <cfelse>
                <cftransaction>
                    <cfif structKeyExists(arguments, "productId") 
                        AND val(arguments.productId)
                    >
                        <!--- Editing the product(product id is available) --->
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
                        <cfset local.productid = arguments.productId>
                        <cfset local.structResult["edit"] = true>
                    <cfelse>
                        <!--- Creating new product(product id not available or 0) --->
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
                        <cfset local.productid = local.productResult.generatedkey>
                        <cfset local.structResult["insert"] = true>
                    </cfif>
                    <!--- Adding new image to db if any and setting the default image --->
                    <cfset local.setDefaultImageResult=addOrEditProductImages(
                        fileNames=local.fileNames,
                        defaultImageId=arguments.defaultImage,
                        productId=local.productid
                    )>
                    <cfif structKeyExists(local.setDefaultImageResult, "success")>
                        <!--- If setting default is successfull --->
                        <cfif structKeyExists(arguments, "deletedProducts")>
                            <!--- If there is any product to delete --->
                            <cfset deleteImage(deletedIdList=arguments.deletedProducts)>
                        </cfif>
                        <!--- Passing new product details to js to create or edit element --->
                        <cfset local.structResult["productDetails"]["productId"] = local.productid>
                        <cfif arguments.currentSubcategoryID EQ arguments.formSubCategoryId>
                            <!--- If element is created or edited to same subcategory --->
                            <cfset local.structResult["isSameSubcategoryID"] = true>
                            <cfset local.structResult["productDetails"]["defaultImage"]= arguments.defaultImage>
                        </cfif>
                        <cfset local.structResult["success"] = true>
                    <cfelse>
                        <!--- If setting default image failed in add product --->
                        <cftransaction action="rollback">
                        <cfset local.structResult["defaultImageError"] = "Error occured while setting default image please try again">
                        <cfset local.structResult["insert"] = false>
                        <cfset local.structResult["edit"] = false>
                        <cfset local.isError = true>
                    </cfif>
                </cftransaction>
            </cfif>
        </cfif>
        <cfif local.isError AND arrayLen(local.Filenames)>
            <cfloop array="#local.fileNames#" item="local.fileArrayItem">
                <cfif fileExists(expandPath(local.uploadLocation &'/' &local.fileArrayItem.serverfile))>
                    <cffile action="delete" file="#expandPath(local.uploadLocation &'/' &local.fileArrayItem.serverfile)#">
                </cfif>
            </cfloop>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <!--- Delete product--->
    <cffunction name = "deleteProduct" access = "remote" returntype = "struct" returnformat = "json">
        <cfargument name = "productId" required = "true" type = "integer">

        <cfset local.resultStruct = structNew()>
        <cfquery result="local.deleteResult">
            UPDATE
                tblProduct
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfSqlType="integer">
        </cfquery>

        <cfif local.deleteResult.recordCount>
            <cfset local.resultStruct["success"] = true>
        <cfelse>
            <cfset local.resultStruct["error"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Delete image of a product --->
    <cffunction name = "deleteImage" returntype="struct">
        <cfargument name  ="deletedIdList" required = "true" type = "string">

        <cfset local.resultStruct = structNew()>
        <cfquery result="local.deleteResult">
            UPDATE
                tblProductImages
            SET
                fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">,
                fldactive = 0
            WHERE
                fldProductImage_ID IN (<cfqueryparam value = "#arguments.deletedIdList#" list="true" cfSqlType="integer">)
                AND fldDefaultImage=0;
        </cfquery>
        <cfif local.deleteResult.recordCount>
            <cfset local.resultStruct["success"] = true>
        </cfif>
        <cfreturn local.resultStruct>
    </cffunction>

    <!--- Add edit product image--->
    <cffunction name="addOrEditProductImages"returntype="struct">
        <cfargument name = "defaultImageId" required = "true" type = "string">
        <cfargument name = "fileNames" required = "true" type = "array">
        <cfargument name = "productId" required = "true" type = "integer">

        <cfset local.resultStruct = structNew()>

        <cftransaction>
            <cfif val(arguments.productId)>
                <!--- Removing current product image --->
                <cfquery result="local.removeDefault">
                    UPDATE
                        tblProductImages
                    SET
                        fldDefaultImage = 0,
                        fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                    WHERE
                        fldProductId = <cfqueryparam value = "#arguments.productId#" cfSqlType="integer">
                        AND fldDefaultImage =1;
                </cfquery>
            </cfif>

            <cfif isNumeric(arguments.defaultImageId)>
                <!--- If id is passed as defaultImageId --->
                <cfquery result="local.setDefault">
                    UPDATE
                        tblProductImages
                    SET
                        fldDefaultImage = 1,
                        fldUpdatedBy = <cfqueryparam value = "#session.adminSession.userId#" cfSqlType="integer">
                    WHERE
                        fldProductImage_ID = <cfqueryparam value = "#arguments.defaultImageId#" cfSqlType="integer">;
                </cfquery>
                <cfif local.setDefault.recordCount>
                    <cfset local.resultStruct["success"] =true>
                </cfif>
            <cfelse>
                <!--- If new image position is passed as default image id --->
                <cfset local.newDefaultImageIndex = listLast(arguments.defaultImageId,'_')>
            </cfif>

            <cfif arrayLen(arguments.fileNames)>
                <!--- If there is any image to add --->
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
                    <cfloop array="#arguments.fileNames#" item="local.fileArrayItem" index="local.fileArrayIndex">
                        <cfif local.fileArrayIndex NEQ 1>,</cfif>
                        (
                            <cfqueryparam value='#arguments.productid#' cfsqltype="integer">,
                            <cfqueryparam value='#local.fileArrayItem.serverfile#' cfsqltype="varchar">,
                            <cfif structKeyExists(local, "newDefaultImageIndex") AND local.newDefaultImageIndex EQ local.fileArrayIndex>
                                1,
                            <cfelse>
                                0,
                            </cfif>
                            <cfqueryparam value='#session.adminSession.userId#' cfsqltype="integer">
                        )
                        <cfif structKeyExists(local, "newDefaultImageIndex") 
                            AND local.newDefaultImageIndex EQ local.fileArrayIndex
                        >
                            <cfset local.resultStruct["success"] =true>
                        </cfif>
                    </cfloop>
                </cfquery>
            </cfif>
            <cfif NOT structKeyExists(local.resultStruct,"success")>
                <!--- NO image is set as default so undo changes --->
                <cfset local.resultStruct["error"] = true>
                <cftransaction action="rollback">
            </cfif>
        </cftransaction>
        <cfreturn local.resultStruct>
    </cffunction>
</cfcomponent>