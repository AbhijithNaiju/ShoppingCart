<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./style/adminStyle.css">
        <link rel="stylesheet" href="../style/bootstrap.min.css">
        <title>Document</title>
    </head>
    <body>
        <cfset currentTemplate = listLast(GetCurrentTemplatePath(),'\')>
        <cfinclude  template="./header.cfm">
        <cfset adminObject = createObject("component","components.admin")>

        <div class="mainBody">
            <cfif structKeyExists(form, "categoryActionBtn")>
                <cfset resultStruct = adminObject.editCategory(
                                                                categoryName=form.categoryName,
                                                                categoryId=form.categoryActionBtn
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
                    <button class="btn btn-success" onclick="openModal(0)">ADD</button>
                </div>
                <div class="d-flex flex-column">
                    <cfset categoryData = adminObject.getCategories()>
                    <cfoutput>
                        <cfloop query="categoryData">
                            <div class="categoryItem d-flex justify-content-between align-items-center">
                                <div>#categoryData.fldCategoryName#</div>
                                <div class="d-flex w-50 justify-content-between">
                                    <button class="btn btn-primary" onclick="openModal(this)" value="#categoryData.fldCategory_ID#">Edit</button>
                                    <button class="btn btn-danger" onclick="deleteCategory(this)"  value="#categoryData.fldCategory_ID#">Delete</button>
                                    <a href="subcategory.cfm?categoryId=#categoryData.fldCategory_ID#" class="btn btn-success">Open</a>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                </div>
            </div>
            <div id="addModal" class="displayNone">
                <form method="post" id="modalForm" class="modalBody mx-auto p-3 d-flex flex-column">
                    <h4 id="modalHeading"></h4>
                    <div>
                        <label for="categoryName">CategoryName</label>
                        <input type="text" id="categoryName" name="categoryName" class="form-control my-3" required>
                    </div>
                    <div class="d-flex justify-content-around mt-auto">
                        <button type="button" class="btn btn-secondary w-50 mx-1" onclick="closeModal()">Close</button>
                        <button class="btn btn-success w-50 mx-1" id="categoryActionBtn" name = "categoryActionBtn"></button>
                    </div>
                </form>
            </div>
        </div>
        <script src="../js/jquery-3.7.1.js"></script>
        <script src="./js/admin.js"></script>
    </body>
</html>