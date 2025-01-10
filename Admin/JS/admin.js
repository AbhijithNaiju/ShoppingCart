function loginValidate()
{
    
    let userName = $("#userName").val();
    let password = $("#password").val();
    $(".errorMessage").text("");
    error = false;
    if(!userName.trim().length)
    {
        $("#userNameError").text("Please enter email Or phone number");
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