<cfinclude  template="./header.cfm">

<div class="mainBody">
    <cfif structKeyExists(form, "modalCategorySubmit")>
        <cfset resultStruct = application.adminObject.editCategory(
                                                        categoryName=form.categoryName,
                                                        categoryId=form.modalCategorySubmit
                                                    )>
        <cfif structKeyExists(resultStruct, "error")>
            <div class="errorMessage text-center">
                <cfoutput>
                #resultStruct.error#
                </cfoutput>
            </div>
        </cfif>
    </cfif>
    <div class="categoryBody m-auto border p-4 shadow rounded">
        <div class="categoryHeading d-flex justify-content-between my-2">
            <h3 class="">CATEGORIES</h3>
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
        <div class="d-flex flex-column">
            <cfset categoryData = application.adminObject.getCategories()>
            <cfoutput>
            <cfif categoryData.recordCount>
                <cfloop query="categoryData">
                    <div class="categoryItem d-flex justify-content-between align-items-center my-1">
                        <div>#categoryData.fldCategoryName#</div>
                        <div class="d-flex justify-content-between categoryButtons">
                            <button 
                                type="button" 
                                class="btn btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="##addModal"
                                onclick="openCategoryModal({categoryId:#categoryData.fldCategory_ID#,categoryName:'#categoryData.fldCategoryName#'})"
                            >
                                <img src="../assets/images/edit-icon.png">
                            </button>
                            <button 
                                class="btn btn-sm" 
                                onclick="deleteCategory(this)" 
                                value="#categoryData.fldCategory_ID#">
                                <img src="../assets/images/delete-icon.png">
                            </button>
                            <a 
                            href="subcategory.cfm?categoryId=#categoryData.fldCategory_ID#" 
                            class="btn btn-sm">
                            <img src="../assets/images/open-icon.png">
                            </a>
                        </div>
                    </div>
                </cfloop>
            <cfelse>
                <div class="categoryItem d-flex justify-content-between align-items-center">
                    No Category Found
                </div>
            </cfif>
            </cfoutput>
        </div>
    </div>
    <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
        <div class="modal-dialog">
            <form method="post" id="modalForm" class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modalHeading"></h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div  class=" mx-auto p-3 d-flex flex-column">
                        <h4 id="modalHeading"></h4>
                        <div>
                            <label for="categoryName">
                                CategoryName
                            </label>
                            <input type="text" id="categoryName" name="categoryName" class="form-control my-3" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button 
                        class="btn btn-success mx-1" 
                        id="modalCategorySubmit" 
                        name = "modalCategorySubmit">
                    </button>
                </div>
                </div>
            </form>
        </div>
    </div>
<cfinclude  template="footer.cfm">