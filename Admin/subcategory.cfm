<cfinclude  template="./header.cfm">
<cfif structKeyExists(url, "CategoryId") AND len(url.CategoryId)>
    <div class="mainBody">
        <cfif structKeyExists(form, "modalSubCatSubmit")>
            <cfset resultStruct = application.adminObject.editSubCategory(
                                                                categoryId=form.formCategoryId,
                                                                subCategoryName=form.subCategoryName,
                                                                subCategoryId=form.modalSubCatSubmit
                                                            )>
            <cfif structKeyExists(resultStruct, "error")>
                <div class="errorMessage text-center">
                    <cfoutput>
                    #resultStruct.error#
                    </cfoutput>
                </div>
            </cfif>
        </cfif>
        <cfset variables.subCategoryData = application.adminObject.getSubCategories(categoryId = url.categoryId)>
        <div class="categoryBody m-auto border rounded p-3 shadow">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <cfif arrayLen(variables.subCategoryData)>
                        <h3 class="">
                            <a 
                                href="./index.cfm" 
                                class = "text-dark text-decoration-none">
                                    <i class="fa-solid fa-arrow-left me-3"></i>
                            </a>
                            #variables.subCategoryData[1].categoryName#
                        </h3>
                    </cfif>
                    <button 
                        type="button" 
                        class="btn btn-success btn-sm" 
                        data-bs-toggle="modal" 
                        data-bs-target="##addModal"
                        onclick="openSubCategoryModal({CategoryId:#url.categoryId#})"
                    >
                        Add +
                    </button>
                </div>
                <cfif arrayLen(variables.subCategoryData)>
                    <div class="d-flex flex-column categoryList">
                        <cfloop array="#variables.subCategoryData#" item="subcategoryItem">
                            <div class="categoryItem d-flex justify-content-between align-items-center my-1">
                                <div>#subcategoryItem.subCategoryName#</div>
                                <div class="d-flex justify-content-between categoryButtons">
                                    <button 
                                        type="button" 
                                        class="btn btn-sm" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="##addModal"
                                        onclick="openSubCategoryModal({CategoryId:#url.categoryId#,subCategoryId:#subcategoryItem.subCategoryId#,subCategoryName:'#subcategoryItem.subCategoryName#'})"
                                        value="#subcategoryItem.subCategoryId#"
                                    >
                                        <img src="../assets/images/edit-icon.png">
                                    </button>
                                    <button 
                                        class="btn btn-sm" 
                                        onclick="deleteSubCategory(this)" 
                                        value="#subcategoryItem.subCategoryId#">
                                        <img src="../assets/images/delete-icon.png">
                                    </button>
                                    <a 
                                        href="product.cfm?subCategoryId=#subcategoryItem.subCategoryId#"
                                        class="btn btn-sm">
                                        <img src="../assets/images/open-icon.png">
                                    </a>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                <cfelse>
                    <div class="categoryItem d-flex justify-content-between align-items-center">
                        No Subcategory Found
                    </div>
                </cfif>
            </cfoutput>
        </div>
        <cfset categoryData = application.adminObject.getCategories()>
        <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
            <div class="modal-dialog">
                <form method="post" id="modalForm" class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="modalHeading"></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class = "form-group my-2">
                                <label for="categorySelect">Category Name</label>
                            <cfoutput>
                                <select name="formCategoryId" id = "categorySelect" class = "form-control" required>
                                    <cfloop query="categoryData">
                                        <option value="#categoryData.fldCategory_ID#">
                                            #categoryData.fldcategoryName#
                                        </option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                            </div>
                        <div class = "form-group my-2">
                            <label for="subCategoryName">Subcategory Name</label>
                            <input type="text" id="subCategoryName" name="subCategoryName" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button 
                            class="btn btn-success mx-1" 
                            id="modalSubCatSubmit" 
                            name = "modalSubCatSubmit">
                        </button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
<cfelse>
    <cflocation  url="./index.cfm" addtoken=false>
</cfif>
<cfinclude  template="footer.cfm">