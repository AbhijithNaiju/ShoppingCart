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
			url:"./Components/admin.cfc?method=logOut",
			success: function() {
				location.reload();
			}
		});
	}
}

function openModal(categoryId)
{
    $("#addModal").removeClass("displayNone")
    if(categoryId.value)
    {
        let editFieldValue=categoryId.parentElement.previousElementSibling.innerHTML;
        $("#modalHeading").text("Edit");
        $("#categoryActionBtn").val(categoryId.value);
        $("#categoryName").val(editFieldValue);
        $("#categoryActionBtn").text("EDIT");

    }
    else
    {
        $("#modalHeading").text("Add");
        $("#categoryActionBtn").val(0);
        $("#categoryActionBtn").text("ADD");
    }
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
            url:"./Components/admin.cfc?method=deleteCategory",
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