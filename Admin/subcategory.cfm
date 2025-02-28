<cfinclude  template="./header.cfm">
<cfif structKeyExists(url, "categoryId") AND len(url.categoryId) AND isNumeric(url.categoryId)>
    <div class="mainBody">
        <cfset variables.subCategoryData = application.adminObject.getSubCategories(categoryId = url.categoryId)>
        <cfset variables.categoryQuery = application.adminObject.getCategories()>
        <cfset variables.categoryData = {}>
        <cfloop query="variables.categoryQuery">
            <cfset variables.categoryData[variables.categoryQuery.fldCategory_ID] = variables.categoryQuery.fldCategoryName>
        </cfloop>
        <div class="categoryBody mx-auto my-5 border rounded p-3 shadow">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <cfif structKeyExists(variables.categoryData, url.categoryId)>
                        <h3>
                            <a 
                                href="./index.cfm" 
                                class = "text-dark text-decoration-none">
                                    <i class="fa-solid fa-arrow-left me-3"></i>
                            </a>
                            #variables.categoryData[url.categoryId]#
                        </h3>
                    </cfif>
                    <button 
                        type="button" 
                        class="btn btn-success btn-sm" 
                        data-bs-toggle="modal" 
                        data-bs-target="##addModal"
                        onclick="openSubCategoryModal(#url.categoryId#,0)"
                    >
                        Add +
                    </button>
                </div>
                <div class="d-flex flex-column categoryList" id="subcategoryList">
                    <cfif arrayLen(variables.subCategoryData)>
                        <cfloop array="#variables.subCategoryData#" item="subcategoryItem">
                            <div 
                                class="categoryItem d-flex justify-content-between align-items-center my-1"
                                id="subCategory#subcategoryItem.subCategoryId#"
                            >
                                <div class = "subcategoryName">#subcategoryItem.subCategoryName#</div>
                                <div class="d-flex justify-content-between categoryButtons">
                                    <button 
                                        type="button" 
                                        class="btn btn-sm" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="##addModal"
                                        onclick="openSubCategoryModal(#url.categoryId#,#subcategoryItem.subCategoryId#)"
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
                    </cfif>
                </div>
                <div 
                    class="categoryItem"
                    id="noSubcategoryError"
                >
                    <cfif arrayLen(variables.subCategoryData) EQ 0>
                        No Subcategory Found
                    </cfif>
                </div>
            </cfoutput>
        </div>
        <div class="modal fade" tabindex="-1" id="addModal" data-bs-backdrop="static">
            <div class="modal-dialog">
                <form method="post" id="addSubcategoryForm" class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="modalHeading"></h1>
                        <button type="reset" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class = "form-group my-2">
                            <label for="categorySelect">Category Name</label>
                            <cfoutput>
                                <select name="formCategoryId" id = "categorySelect" class = "form-control" required>
                                    <cfloop collection="#variables.categoryData#" item="categoryKey">
                                        <option value="#categoryKey#">
                                            #variables.categoryData[categoryKey]#
                                        </option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                            </div>
                            <div class = "form-group my-2">
                                <label for="subCategoryName">Subcategory Name</label>
                                <input type="text" id="subCategoryName" name="subCategoryName" class="form-control" required>
                                <div class = "errorMessage modalError" id="modalError"></div>
                                <cfoutput>
                                    <input type="hidden" id="currentCategoryId" value="#url.categoryId#" class="form-control">
                                </cfoutput>
                            </div>
                    </div>
                    <div class="modal-footer">
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button 
                            type = "button"
                            class="btn btn-success mx-1" 
                            id="modalSubCatSubmit" 
                            name = "modalSubCatSubmit">
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<cfelse>
    <cflocation  url="./index.cfm" addtoken=false>
</cfif>
<cfinclude  template="footer.cfm">