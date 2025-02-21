<cfinclude  template="./header.cfm">
<cfif structKeyExists(url, "subCategoryId") AND len(url.subCategoryId)>
    <div class="mainBody">
        <cfset productData = application.adminObject.getProducts(subCategoryId = url.subCategoryId)>
        <cfif productData.recordCount EQ 0>
            <cfset variables.subcategoryData = application.adminObject.getCategoryData(subCategoryId = url.subCategoryId)>
        <cfelse>
            <cfset variables.subcategoryData = productData>
        </cfif>
        <div class="categoryBody m-auto border rounded shadow px-4 py-3">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <h3 class="text-dark d-flex align-items-center"> 
                        <a 
                            href="./subcategory.cfm?categoryId=#variables.subcategoryData.categoryID#" 
                            class = "text-decoration-none text-dark">
                                <i class="fa-solid fa-arrow-left me-3"></i>
                        </a>
                        #variables.subcategoryData.subCategoryName#
                    </h3>
                    <button 
                        type="button" 
                        class="btn btn-success btn-sm" 
                        data-bs-toggle="modal" 
                        data-bs-target="##addModal"
                        onclick="openProductModal({categoryId:#variables.subcategoryData.categoryID#,subCategoryId:#url.subCategoryId#})"
                    >
                        Add +
                    </button>
                </div>
                <div class="d-flex flex-column categoryList">
                    <cfif productData.recordCount>
                        <cfloop query="productData">
                            <div 
                                class="productItem my-2 rounded border shadow-sm p-3 justify-content-between align-items-center"
                                id="product#productData.fldProduct_ID#"
                            >
                                <div class="row">
                                    <button 
                                        type="button" 
                                        class="thumbnailImage col-4" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="##imageModal"
                                        onclick="openImageModal({productId:'#productData.fldProduct_ID#'})"
                                    >
                                        <img
                                            src="../assets/productimages/#productData.fldImageFileName#" 
                                            alt="Image not found" 
                                            class="">
                                    </button>
                                    <div class="col-6 d-flex flex-column">
                                        <div class="productName">#productData.fldProductName#</div>
                                        <div class="brandName">#productData.fldBrandName#</div>
                                        <div class = "mt-auto">
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                            #productData.fldprice+(productData.fldprice*productData.fldtax)/100#
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
                                        >
                                            <img src="../assets/images/edit-icon.png">
                                        </button>
                                        <button 
                                            class="productButtons" 
                                            onclick="deleteProduct(this)" 
                                            value="#productData.fldProduct_ID#"
                                        >
                                            <img src="../assets/images/delete-icon.png">
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    <cfelse>
                        <div class="categoryItem d-flex justify-content-between align-items-center">
                            No Products Found
                        </div>
                    </cfif>
                </div>
            </cfoutput>
        </div>
        <cfset categoryList = application.adminObject.getCategories()>
        <cfset brandData = application.adminObject.getBrands()>
        <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-scrollable">
                <form 
                    method="post" 
                    id="modalForm" 
                    class="modal-content"
                    onsubmit="return productSubmit()"
                    enctype="multipart/form-data"
                >
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="modalHeading"></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                                max="100.00"
                                required
                            >
                        </div>
                        <div class = "form-group my-3" >
                            <label class="mb-2" for="productImages">Product Images</label>
                            <input type="file" multiple id="productImages" name="productImages" class="form-control" required>
                        </div>
                        <input type="hidden" id="productId" value="" name="productId" class="form-control">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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
        <div class="modal fade" tabindex="-1" id="imageModal" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered imageModalDialog">
                <div class="modal-content imageModalContent">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5">Edit image</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="carouselExampleControls" class="carousel" data-ride="carousel">
                            <div class="carousel-inner" id="carouselInner">
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<cfelse>
    <cflocation  url="./index.cfm" addtoken=false>
</cfif>
<cfinclude  template="./footer.cfm">