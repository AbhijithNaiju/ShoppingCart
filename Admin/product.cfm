<cfinclude template="./header.cfm">
<cfif structKeyExists(url, "subCategoryId") AND len(url.subCategoryId) AND isValid("integer",url.subCategoryId)>
    <div class="mainBody">
        <cfset productData = application.adminProductObject.getProducts(subCategoryId = url.subCategoryId)>
        <cfif productData.recordCount>
            <cfset variables.categoryId = variables.productData.categoryId>
            <cfset variables.subCategoryName = variables.productData.subCategoryName>
        <cfelse>
            <cfset variables.subcategoryData = application.adminSubcategoryObject.getSubcategories(subCategoryId = url.subCategoryId)>
            <cfif arrayLen(variables.subcategoryData)>
                <cfset variables.categoryId = variables.subcategoryData[1].categoryId>
                <cfset variables.subCategoryName = variables.subcategoryData[1].subCategoryName>
            </cfif>
        </cfif>
        <cfif structKeyExists(variables, "categoryId")>
            <div class="categoryBody mx-auto my-5 border rounded shadow px-4 py-3">
                <cfoutput>
                    <div class="categoryHeading d-flex justify-content-between my-2">
                        <h3 class="text-dark d-flex align-items-center">
                            <a 
                                href="./subcategory.cfm?categoryId=#variables.categoryId#" 
                                class = "text-decoration-none text-dark">
                                    <i class="fa-solid fa-arrow-left me-3"></i>
                            </a>
                            #variables.subCategoryName#
                        </h3>
                        <button 
                            type="button" 
                            class="btn btn-success btn-sm" 
                            data-bs-toggle="modal" 
                            data-bs-target="##addModal"
                            onclick="openProductModal({categoryId:#variables.categoryId#,subCategoryId:#url.subCategoryId#})"
                        >
                            Add +
                        </button>
                    </div>
                    <div class="d-flex flex-column categoryList" id="productList">
                        <cfif productData.recordCount>
                            <cfloop query="productData">
                                <div 
                                    class="productItem my-2 rounded border shadow-sm p-3 justify-content-between align-items-center"
                                    id="product#productData.fldProduct_ID#"
                                >
                                    <div class="row">
                                        <div 
                                            class="d-flex col-4"
                                        >
                                            <img
                                                src="../assets/productimages/#productData.fldImageFileName#"
                                                alt="Image not found" 
                                                class="thumbnailImage">
                                        </div>
                                        <div class="col-6 d-flex flex-column">
                                            <div class="productName">#productData.fldProductName#</div>
                                            <div class="brandName">#productData.fldBrandName#</div>
                                            <div class = "mt-auto">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                <span class="productPrice">
                                                    #numberFormat(productData.fldprice+(productData.fldprice*productData.fldtax)/100,'__.00')#
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-2 d-flex flex-column justify-content-around">
                                            <button 
                                                type="button" 
                                                class="productButtons" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="##addModal"
                                                onclick="openProductModal({categoryId:#productData.CategoryID#,subCategoryId:#url.subCategoryId#,productId:#productData.fldProduct_ID#})"
                                                value="#productData.fldProduct_ID#"
                                                title="Edit"
                                            >
                                                <img src="../assets/images/edit-icon.png">
                                            </button>
                                            <button 
                                                class="productButtons deleteProductBtn" 
                                                value="#productData.fldProduct_ID#"
                                                title="Delete"
                                            >
                                                <img src="../assets/images/delete-icon.png">
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </cfif>
                    </div>
                    <div class="" id="noProductError">
                        <cfif productData.recordCount EQ 0>
                            No Products Found
                        </cfif>
                    </div>
                </cfoutput>
            </div>
            <cfset categoryList = application.adminCategoryObject.getCategories()>
            <cfset brandData = application.adminProductObject.getBrands()>
            <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
                <div class="modal-dialog modal-dialog-scrollable modal-lg">
                    <form 
                        method="post" 
                        id="productModalForm" 
                        class="modal-content"
                        enctype="multipart/form-data"
                    >
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="modalHeading"></h1>
                            <button type="reset" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class = "form-group my-3">
                                <cfoutput>
                                    <div class = "my-3">
                                        <label class="mb-2" for="categorySelect">Category Name</label>
                                        <select name="formCategoryId" id = "categorySelect" onchange="listSubcategories(this.value)" class = "form-control" required>
                                            <cfloop query="categoryList">
                                                <option value="#categoryList.fldCategory_ID#">
                                                    #categoryList.fldcategoryName#
                                                </option>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <div class = "my-3">
                                        <label class="mb-2" for="subCategorySelect">Subcategory name</label>
                                        <select name="formSubCategoryId" id = "subCategorySelect" class = "form-control" required>
                                        </select>
                                    </div>
                                    <div class = "my-3">
                                        <label class="mb-2" for="brandSelect">Brand Name</label>
                                        <select name="formBrandId" id="brandSelect" class="form-control" required>
                                            <cfloop query="brandData">
                                                <option value="#brandData.fldBrand_ID#">
                                                    #brandData.fldBrandName#
                                                </option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </cfoutput>
                            </div>
                            <div class = "form-group my-3" >
                                <label class="mb-2" for="productName">Product Name</label>
                                <input type="text" id="productName" name="productName" class="form-control" required>
                                <div class = "errorMessage modalError" id="productNameError"></div>
                            </div>
                            <div class = "form-group my-3" >
                                <label class="mb-2" for="productDescription">Product Description</label>
                                <textarea id="productDescription" name="productDescription" class="form-control" required></textarea>
                            </div>
                            <div class = "form-group my-3" >
                                <label class="mb-2" for="productPrice">Product Price</label>
                                <input type="number" step="0.01" id="productPrice" name="productPrice" class="form-control" required>
                            </div>
                            <div class = "form-group my-3" >
                                <label class="mb-2" for="productTax">Product Tax</label>
                                <input 
                                    type="number" 
                                    step="0.01" 
                                    id="productTax" 
                                    name="productTax" 
                                    class="form-control"
                                    required
                                >
                                <div class = "errorMessage modalError" id="productTaxError"></div>
                            </div>
                            <div class = "form-group my-3" >
                                <label class="mb-2" for="productImages">Product Images</label>
                                <input 
                                    type="file" 
                                    id="productImages" 
                                    name="productImages" 
                                    class="form-control" 
                                    accept="image/*"
                                    required
                                    multiple 
                                >
                                <div class = "errorMessage modalError" id="productImageError"></div>
                            </div>
                            <div id="editImageBody" class="editImageBody row p-2">

                            </div>
                            <input type="hidden" id="productId" name="productId" class="form-control">
                            <cfoutput>
                                <input type="hidden" id="currentSubcategoryID" value="#url.subCategoryId#" name="currentSubcategoryID" class="form-control">
                            </cfoutput>
                        </div>
                            <div class = "errorMessage modalError text-center" id="modalError"></div>
                        <div class="modal-footer">
                            <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button 
                                class="btn btn-success mx-1" 
                                id="modalProductSubmit" 
                                name = "modalProductSubmit">
                            </button>
                        </div>
                        </div>
                    </form>
                </div>
            </div>
        <cfelse>
            <div class = "text-center">
                 <h1>Error occured</h1>
            </div>
        </cfif>
    </div>
<cfelse>
    <cflocation url="./index.cfm" addtoken=false>
</cfif>
<cfinclude template="./footer.cfm">