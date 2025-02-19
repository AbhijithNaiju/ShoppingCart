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
    <div class="categoryBody m-auto border p-3">
        <div class="categoryHeading d-flex justify-content-between my-2">
            <h3 class="">CATEGORIES</h3>
            <button class="btn btn-success" onclick="openCategoryModal(0)">Add +</button>
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
                                class="btn  btn-sm" 
                                onclick="openCategoryModal({categoryId:#categoryData.fldCategory_ID#,categoryName:'#categoryData.fldCategoryName#'})"
                                value="#categoryData.fldCategory_ID#">
                                <img src="../assets/images/edit-icon.png">
                            </button>
                            <button 
                                class="btn btn-sm" 
                                onclick="deleteCategory(this)" 
                                value="#categoryData.fldCategory_ID#">
                                <img src="../assets/images/delete-icon.png">
                            </button>
                            <a 
                            href="subcategory.cfm?categoryId=#categoryData.fldCategory_ID#&categoryName=#categoryData.fldCategoryName#" 
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
    <div id="addModal" class="displayNone">
        <form method="post" id="modalForm" class="categoryModalBody mx-auto p-3 d-flex flex-column">
            <h4 id="modalHeading"></h4>
            <div>
                <label for="categoryName">
                    CategoryName
                </label>
                <input type="text" id="categoryName" name="categoryName" class="form-control my-3" required>
            </div>
            <div class="d-flex justify-content-around mt-auto">
                <button 
                    type="button" 
                    class="btn btn-secondary w-50 mx-1" 
                    onclick="closeModal()">
                    Close
                </button>
                <button 
                    class="btn btn-success w-50 mx-1" 
                    id="modalCategorySubmit" 
                    name = "modalCategorySubmit">
                </button>
            </div>
        </form>
    </div>
</div>
<cfinclude  template="footer.cfm">