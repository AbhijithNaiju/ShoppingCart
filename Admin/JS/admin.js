function loginValidate()
{
    
    let userName = $("#userName").val();
    let password = $("#password").val();
    $(".errorMessage").text("");
    error = false;
    if(!userName.trim().length)
    {
        $("#userNameError").text("Please enter email or phone number");
        error = true
    }
    if(!password.trim().length)
    {
        $("#passwordError").text("Please enter the password");
        error = true
    }
    if(error)
        return false
}
function logout()
{
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"./components/admin.cfc?method=logOut",
			success: function() {
				location.reload();
			}
		});
	}
}

function openCategoryModal(categoryData)
{
    $("#addModal").removeClass("displayNone")
    if(categoryData.id)
    {
        $("#modalHeading").text("Edit category");
        $("#modalCategorySubmit").val(categoryData.id);
        $("#categoryName").val(categoryData.name);
        $("#modalCategorySubmit").text("EDIT");

    }
    else
    {
        $("#modalHeading").text("Add category");
        $("#modalCategorySubmit").val(0);
        $("#modalCategorySubmit").text("ADD");
    }
}
function openSubCategoryModal(subCategoryData)
{
    $("#addModal").removeClass("displayNone")
    $("#categorySelect").val(subCategoryData.CategoryId);
    if(subCategoryData.subCategoryId)
    {
        $("#modalHeading").text("Edit Sub Category");
        $("#modalSubCatSubmit").val(subCategoryData.subCategoryId);
        $("#subCategoryName").val(subCategoryData.subCategoryName);
        $("#modalSubCatSubmit").text("EDIT");
    }
    else
    {
        $("#modalHeading").text("Add Sub Category");
        $("#modalSubCatSubmit").val(0);
        $("#modalSubCatSubmit").text("ADD");
    }
}
function openProductModal(productData)
{
    $("#addModal").removeClass("displayNone")
    $("#categorySelect").val(productData.categoryId);
    addSubcategories(productData.categoryId);
    $("#subCategorySelect").val(productData.subCategoryId);
    if(productData.subCategoryId)
    {
        $("#modalHeading").text("Edit Sub Category");
        $("#modalSubCatSubmit").val(productData.subCategoryId);
        $("#subCategoryName").val(productData.subCategoryName);
        $("#modalSubCatSubmit").text("EDIT");
    }
    else
    {
        $("#modalHeading").text("Add Sub Category");
        $("#modalSubCatSubmit").val(0);
        $("#modalSubCatSubmit").text("ADD");
    }
}
function addSubcategories(categoryId)
{
    $("#subCategorySelect").empty();
    $.ajax({
        type:"POST",
        url:"./components/admin.cfc?method=getSubcategories",
        data:{categoryId:categoryId},
        success: function(result) {
            if(result)
            {
                resultJson=JSON.parse(result);
                const jsonKeys=Object.keys(resultJson);
                for(i=0;i<jsonKeys.length;i++)
                {
                    subContactId=jsonKeys[i];
                    var optionObj = document.createElement('option');
                    optionObj.innerHTML=resultJson[subContactId];
                    optionObj.value=subContactId;
                    document.getElementById("subCategorySelect").appendChild(optionObj);
                }
            }
            else
            {
                alert("Error occured while deleteing");
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}
function closeModal()
{
    $("#addModal").addClass("displayNone")
    $("#modalForm")[0].reset();
}

function  deleteCategory(categoryId)
{
    if(confirm("This will delete the category and its contents. Confirm delete?"))
    {
        $.ajax({
            type:"POST",
            url:"./components/admin.cfc?method=deleteCategory",
            data:{categoryId:categoryId.value},
            success: function(result) {
                if(result)
                {
                    categoryId.parentElement.parentElement.remove();
                }
                else
                {
                    alert("Error occured while deleteing");
                }
            },
            error:function()
            {
                alert("An error occured")
            }
        });
    }
}
function  deleteSubCategory(deleteButton)
{
    if(confirm("This will delete the sub category and its contents. Confirm delete?"))
    {
        $.ajax({
            type:"POST",
            url:"./components/admin.cfc?method=deleteSubCategory",
            data:{subCategoryId:deleteButton.value},
            success: function(result) {
                if(result)
                {
                    deleteButton.parentElement.parentElement.remove();
                }
                else
                {
                    alert("Error occured while deleteing");
                }
            },
            error:function()
            {
                alert("An error occured")
            }
        });
    }
}