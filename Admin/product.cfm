<cfinclude  template="./header.cfm">
<cfif structKeyExists(url, "subCategoryId") AND len(url.subCategoryId)>
    <cfset adminObject = createObject("component","components.admin")>
    <div class="mainBody">
        <cfset productData = adminObject.getProducts(subCategoryId = url.subCategoryId)>
        <cfset categoryData = adminObject.getcategoryData(subCategoryId = url.subCategoryId)>
        <div class="categoryBody m-auto border p-3">
            <cfoutput>
                <div class="categoryHeading d-flex justify-content-between my-2">
                    <cfif structKeyExists(url, "subCategoryName")>
                        <h3 class="">#url.subCategoryName#</h3>
                    </cfif>
                    <button 
                        class="btn btn-success" 
                        onclick="openProductModal({categoryId:#categoryData.fldCategoryID#,subCategoryId:#url.subCategoryId#})">
                        ADD
                    </button>
                </div>
                <div class="d-flex flex-column categoryList">
                    <cfloop query="productData">
                        <div class="categoryItem d-flex justify-content-between align-items-center">
                            <div>#productData.fldSubCategoryName#</div>
                            <div class="d-flex w-50 justify-content-between">
                                <button 
                                    class="btn btn-primary" 
                                    onclick=openProductModal({CategoryId:#categoryData.fldCategoryID#,subCategoryId:#productData.fldSubCategory_ID#,subCategoryName:"#productData.fldSubCategoryName#"})
                                    value="#productData.fldSubCategory_ID#">
                                    Edit
                                </button>
                                <button 
                                    class="btn btn-danger" 
                                    onclick="deleteCategory(this)" 
                                    value="#productData.fldSubCategory_ID#">
                                    Delete
                                </button>
                                <a 
                                    href="product.cfm?subCategoryId=#productData.fldSubCategory_ID#" 
                                    class="btn btn-success">
                                    Open
                                </a>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </cfoutput>
        </div>
        <cfset categoryData = adminObject.getCategories()>
        <cfset subCategoryData = adminObject.getSubCategories(categoryid=categoryData.fldCategory_ID)>
        <div id="addModal" class="displayNone">
            <form method="post" id="modalForm" class="subCategoryModalBody mx-auto p-3 d-flex flex-column">
                <h4 id="modalHeading"></h4>
                <div class = "form-group">
                    <cfoutput>
                        <select name="formCategoryId" id = "categorySelect" onchange="addSubcategories(this.value)" class = "form-control" required>
                            <cfloop query="categoryData">
                                <option value="#categoryData.fldCategory_ID#">
                                    #categoryData.fldcategoryName#
                                </option>
                            </cfloop>
                        </select>
                        <select name="formSubCategoryId" id = "subCategorySelect" class = "form-control" required>

                        </select>
                    </cfoutput>
                    </div>
                <div class = "form-group" >
                    <label for="productName">Product Name</label>
                    <input type="text" id="productName" name="productName" class="form-control my-3" required>
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
<cfinclude  template="./footer.cfm">
