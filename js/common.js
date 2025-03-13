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

    $("#buyNow").click(function(){
		productId=this.value;
		addToCart(productId,"order");
		location.href="./orderPage.cfm"
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
});
function addToCart(productId,redirect){
    $.ajax({
        type:"POST",
        url:"components/cart.cfc?method=addToCart",
        data:{productId:productId},
        success: function(result) {
            addToCartResult=JSON.parse(result)
            if(addToCartResult.redirect){
                if(redirect && redirect==="order"){
                    location.href="login.cfm?redirect=order&productId="+productId
                }else{
                    location.href="login.cfm?redirect=cart&productId="+productId
                }
            }else{
                Swal.fire({
                    position: "top",
                    toast: true,
                    icon: "success",
                    title: "Product added to cart",
                    showConfirmButton: false,
                    timer: 1500
                  });
                if(addToCartResult.cartCount){
                    $("#cartCount").text(addToCartResult.cartCount);
                }
            }
        },error: function(){
            alert("Error occured");
        }
    });
}