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
        <cfset subCategoryData = application.adminObject.getSubCategories(categoryId = url.categoryId)>
        <div class="categoryBody m-auto border p-3">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <cfif structKeyExists(url, "categoryName")>
                        <h3 class="">#url.categoryName#</h3>
                    </cfif>
                    <button 
                        class="btn btn-success" 
                        onclick="openSubCategoryModal({CategoryId:#url.categoryId#})"
                    >
                        Add +
                    </button>
                </div>
                <div class="d-flex flex-column categoryList">
                    <cfif structCount(subCategoryData)>
                        <cfloop collection="#subCategoryData#" item="subCatoryId">
                            <div class="categoryItem d-flex justify-content-between align-items-center my-1">
                                <div>#subCategoryData[subCatoryId]#</div>
                                <div class="d-flex justify-content-between categoryButtons">
                                    <button 
                                        class="btn btn-sm" 
                                        onclick="openSubCategoryModal({CategoryId:#url.categoryId#,subCategoryId:#subCatoryId#,subCategoryName:'#subCategoryData[subCatoryId]#'})"
                                        value="#subCatoryId#">
                                        <img src="../assets/images/edit-icon.png">
                                    </button>
                                    <button 
                                        class="btn btn-sm" 
                                        onclick="deleteSubCategory(this)" 
                                        value="#subCatoryId#">
                                        <img src="../assets/images/delete-icon.png">
                                    </button>
                                    <a 
                                        href="product.cfm?subCategoryId=#subCatoryId#&subCategoryName=#subCategoryData[subCatoryId]#"
                                        class="btn btn-sm">
                                        <img src="../assets/images/open-icon.png">
                                    </a>
                                </div>
                            </div>
                        </cfloop>
                    <cfelse>
                        <div class="categoryItem d-flex justify-content-between align-items-center">
                            No Subcategory Found
                        </div>
                    </cfif>
                </div>
            </cfoutput>
        </div>
        <cfset categoryData = application.adminObject.getCategories()>
        <div id="addModal" class="displayNone">
            <form method="post" id="modalForm" class="subCategoryModalBody mx-auto p-3 d-flex flex-column">
                <h4 id="modalHeading"></h4>
                <div class = "form-group">
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
                <div class = "form-group" >
                    <label for="subCategoryName">Sub Category Name</label>
                    <input type="text" id="subCategoryName" name="subCategoryName" class="form-control my-3" required>
                </div>
                <div class="d-flex justify-content-around mt-auto">
                    <button type="button" class="btn btn-secondary w-50 mx-1" onclick="closeModal()">Close</button>
                    <button class="btn btn-success w-50 mx-1" id="modalSubCatSubmit" name = "modalSubCatSubmit"></button>
                </div>
            </form>
        </div>
    </div>
<cfelse>
    <cflocation  url="./index.cfm" addtoken=false>
</cfif>
<cfinclude  template="footer.cfm">