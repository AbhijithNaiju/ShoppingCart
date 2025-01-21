<cfinclude  template="./header.cfm">
<cfif structKeyExists(url, "subCategoryId") AND len(url.subCategoryId)>
    <div class="mainBody">
        <cfset productData = application.adminObject.getProducts(subCategoryId = url.subCategoryId)>
        <cfset categoryData = application.adminObject.getcategoryData(subCategoryId = url.subCategoryId)>
        <div class="categoryBody m-auto border p-3">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <cfif structKeyExists(url, "subCategoryName")>
                        <a href="./productListing.cfm?categoryId=#categoryData.fldCategoryID#" class = "test-decoration-none text-dark">
                            <h3 class=""> #url.subCategoryName#</h3>
                        </a>
                    </cfif>
                    <button 
                        class="btn btn-success" 
                        onclick="openProductModal({categoryId:#categoryData.fldCategoryID#,subCategoryId:#url.subCategoryId#})">
                        ADD
                    </button>
                </div>
                <div class="d-flex flex-column categoryList">
                    <cfif productData.recordCount>
                        <cfloop query="productData">
                            <div class="productItem my-2 border p-1 justify-content-between align-items-center">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div class="productName">#productData.fldProductName#</div>
                                        <div class="brandName">#productData.fldBrandName#</div>
                                    </div>
                                    <div>#productData.fldprice#</div>
                                    <button 
                                        class="thumbnailImage"
                                        onclick="openImageModal({productId:'#productData.fldProduct_ID#'})"
                                    >
                                        <img 
                                            src="../assets/productimages/#productData.fldImageFileName#" 
                                            alt="Image not found" 
                                            class="">
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <button 
                                        class="btn btn-secondary w-50" 
                                        onclick="openProductModal({categoryId:#categoryData.fldCategoryID#,subCategoryId:#url.subCategoryId#,productId:#productData.fldProduct_ID#})"
                                        value="#productData.fldProduct_ID#"
                                    >
                                        Edit
                                    </button>
                                    <button 
                                        class="btn btn-secondary w-50" 
                                        onclick="deleteProduct(this)" 
                                        value="#productData.fldProduct_ID#"
                                    >
                                        Delete
                                    </button>
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
        <cfset subCategoryData = application.adminObject.getSubCategories(categoryid=categoryData.fldCategoryID)>
        <div id="addModal" class="displayNone">
            <form 
                method="post" 
                id="modalForm" 
                class="productModalBody mx-auto p-3 d-flex flex-column"
                onsubmit="return productSubmit()"
                enctype="multipart/form-data">
                <h4 id="modalHeading"></h4>
                <div class = "productModalScroll" >
                    <div class = "form-group">
                        <cfoutput>
                            <label for="categorySelect">Category Name</label>
                            <select name="formCategoryId" id = "categorySelect" onchange="listSubcategories(this.value)" class = "form-control" required>
                                <cfloop query="categoryList">
                                    <option value="#categoryList.fldCategory_ID#">
                                        #categoryList.fldcategoryName#
                                    </option>
                                </cfloop>
                            </select>
                            <label for="subCategorySelect">Subcategory name</label>
                            <select name="formSubCategoryId" id = "subCategorySelect" class = "form-control" required>
                            </select>
                            <label for="brandSelect">Brand Name</label>
                            <select name="formBrandId" id="brandSelect" class="form-control" required>
                                <cfloop query="brandData">
                                    <option value="#brandData.fldBrand_ID#">
                                        #brandData.fldBrandName#
                                    </option>
                                </cfloop>
                            </select>
                        </cfoutput>
                    </div>
                    <div class = "form-group" >
                        <label for="productName">Product Name</label>
                        <input type="text" id="productName" name="productName" class="form-control" required>
                    </div>
                    <div class = "form-group" >
                        <label for="productDescription">Product Description</label>
                        <textarea id="productDescription" name="productDescription" class="form-control" required></textarea>
                    </div>
                    <div class = "form-group" >
                        <label for="productPrice">Product Price</label>
                        <input type="number" step="0.01" id="productPrice" name="productPrice" class="form-control" required>
                    </div>
                    <div class = "form-group" >
                        <label for="productTax">Product Tax</label>
                        <input type="number" step="0.01" id="productTax" name="productTax" class="form-control" required>
                    </div>
                    <div class = "form-group" >
                        <label for="productImages">Product Images</label>
                        <input type="file" multiple id="productImages" name="productImages" class="form-control" required>
                    </div>
                    <input type="hidden" id="productId" value="" name="productId" class="form-control">
                </div>
                <div class="errorMessage text-center my-1" id="modalError"></div>
                <div class="d-flex justify-content-around mt-auto">
                    <button type="button" class="btn btn-secondary w-50 mx-1" onclick="closeModal()">Close</button>
                    <button type="submit" class="btn btn-success w-50 mx-1" id="modalProductSubmit" name="modalProductSubmit"></button>
                </div>
            </form>
        </div>
        <div id="imageModal" class="displayNone align-items-center justify-content-center">
            <div id="carouselExampleControls" class="carousel" data-ride="carousel">
                <div class="carousel-inner" id="carouselInner">
                </div>
                <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon bg-dark btn" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                    <span class="carousel-control-next-icon bg-dark btn" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
            <button 
                class="position-absolute imageModalClose btn btn-danger"
                onclick="closeImageModal()"
            >
                Close X
            </button>
        </div>
    </div>
<cfelse>
    <cflocation  url="./index.cfm" addtoken=false>
</cfif>
<cfinclude  template="./footer.cfm">