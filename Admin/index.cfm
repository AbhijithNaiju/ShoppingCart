<cfinclude template="./header.cfm">
<div class="mainBody">
    <div class="categoryBody my-5 mx-auto border px-4 py-3 shadow rounded">
        <div class="categoryHeading d-flex justify-content-between my-2">
            <h3>CATEGORIES</h3>
            <button 
                type="button" 
                class="btn btn-success btn-sm" 
                data-bs-toggle="modal" 
                data-bs-target="#addModal"
                onclick="openCategoryModal(0)"
            >
                Add +
            </button>
        </div>
        <div class="d-flex flex-column" id="categoryList">
            <cfset variables.categoryData = application.adminCategoryObject.getCategories()>
            <cfoutput>
                <cfif variables.categoryData.recordCount>
                    <cfloop query="variables.categoryData">
                        <div 
                            class="categoryItem d-flex justify-content-between align-items-center my-1"
                            id="categoryItem#variables.categoryData.fldCategory_ID#"
                        >
                            <div class = "categoryName">#variables.categoryData.fldCategoryName#</div>
                            <div class="d-flex justify-content-between categoryButtons">
                                <button 
                                    type="button" 
                                    class="btn btn-sm" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="##addModal"
                                    onclick="openCategoryModal(#variables.categoryData.fldCategory_ID#)"
                                >
                                    <img src="../assets/images/edit-icon.png">
                                </button>
                                <button 
                                    class="btn btn-sm" 
                                    onclick="deleteCategory(this)" 
                                    value="#variables.categoryData.fldCategory_ID#">
                                    <img src="../assets/images/delete-icon.png">
                                </button>
                                <a 
                                href="subcategory.cfm?categoryId=#variables.categoryData.fldCategory_ID#" 
                                class="btn btn-sm">
                                <img src="../assets/images/open-icon.png">
                                </a>
                            </div>
                        </div>
                    </cfloop>
                </cfif>
            </cfoutput>
        </div>
        <div class="categoryItem" id="noCategoryError">
            <cfif variables.categoryData.recordCount EQ 0>
                No Category Found
            </cfif>
        </div>
    </div>
    <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
        <div class="modal-dialog">
            <form method="post" id="addCategoryForm" class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalHeading"></h1>
                    <button type="reset" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class=" mx-auto p-3 d-flex flex-column">
                        <h4 id="modalHeading"></h4>
                        <div>
                            <label for="categoryName">
                                CategoryName
                            </label>
                            <input type="text" id="categoryName" name="categoryName" class="form-control mt-3" required>
                            <div class = "errorMessage modalError" id="categoryNameError"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button 
                        type = "button"
                        class="btn btn-success mx-1" 
                        id="modalCategorySubmit" 
                        name = "modalCategorySubmit">
                    </button>
                </div>
                </div>
            </form>
        </div>
    </div>
<cfinclude template="footer.cfm">