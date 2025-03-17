$(document).ready(function(){
    $("#logOutBtn").click(function(){
        Swal.fire({
            title: "Are you sure?",
            text: "You will log out of this page and need to authenticate again to login",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Logout"
          }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    type:"POST",
                    url:"components/user.cfc?method=logOut",
                    success: function(result) {
                        logOutResult=JSON.parse(result)
                        if(logOutResult.success){
                            location.reload();
                        }
                        else{
                            Swal.fire({
                                title: "Error!",
                                text: "Please try again.",
                                icon: "error"
                              });
                        }
                    },error: function(){
                        alert("Error occured");
                    }
                });
            }
        });
    })

    $("#orderSearchClearButton").click(function(){
		$("#orderSearchField").val('');
	});

    $("#signupForm").submit(function(){
		let firstName =$("#firstName").val();
		let lastName =$("#lastName").val();
		let emailId =$("#emailId").val();
		let phoneNumber =$("#phoneNumber").val();
		let password =$("#password").val();
		let confirmPassword =$("#confirmPassword").val();

		let isFirstNameValid = hasSpecialCharsOrWhitespace(firstName,"firstNameError");
		let isLastNameValid = hasSpecialCharsOrWhitespace(lastName,"lastNameError");
		let isEmailValid = validateEmail(emailId,"emailError");
		let isPhoneValid = validatePhoneNumber(phoneNumber,"phoneNumberError");
		let isPasswordValid = validatePassword(password,"passwordError");
		let isConfirmValid = confirmPasswords(password,confirmPassword,"confirmPasswordError");
		if(isFirstNameValid &&
			isLastNameValid &&
			isEmailValid &&
			isPhoneValid &&
			isPasswordValid &&
			isConfirmValid){	
				return true;
			}else{
				return false;
			}
	});

    $("#modalLoginBtn").click(function(){
        const modalUserName = $("#modalUserName").val();
        const modalPassword = $("#modalPassword").val();
        if(modalUserName.length == 0){
            setError(message = "Please enter email or phone",messageLocationId = "modalUserNameError");
        }if(modalPassword.length == 0){
            setError(message = "Please enter your password",messageLocationId = "modalPasswordError");
        }
        if(modalUserName.length && modalPassword.length){
            $.ajax({
                type:"POST",
                url:"components/user.cfc",
                data:{
                    userName:modalUserName,
                    password:modalPassword,
                    method:"userLogin"
                },
                success: function(result) {
                    loginResult=JSON.parse(result)
                    if(loginResult.success){
                        if($("#addToCartId").val()){
                            addToCart(productId=$("#addToCartId").val());
                        }
                    }
                    else{
                        $("#loginModalError").text("Please enter valid username and password");
                    }
                },error: function(){
                    alert("Error occured");
                }
            });
        }
    });
});