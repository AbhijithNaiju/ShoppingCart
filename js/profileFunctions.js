$(document).ready(function(){
    $("#addAddressForm").submit(function(){
		let addressFirstName= $("#addressFirstName").val();
		let addressLastName= $("#addressLastName").val();
		let addressLine1= $("#addressLine1").val();
		let addressLine2= $("#addressLine2").val();
		let city= $("#city").val();
		let state= $("#state").val();
		let addressPhoneNumber= $("#addressPhoneNumber").val();
		let pincode= $("#pincode").val();

		let isAddressFirstNameValid = hasSpecialCharsOrWhitespace(addressFirstName,"FirstNameError");
		let isAddressLastNameValid = hasSpecialCharsOrWhitespace(addressLastName,"LastNameError");
		if(addressLine1.length){
			isAddressLine1Valid = checkSpecialCharacter(addressLine1,"addressLine1Error");
		}else{
			isAddressLine1Valid = false;
			setError(message = "Please fill out this field",messageLocationId = "addressLine1Error")
		}
		let isAddressLine2Valid = checkSpecialCharacter(addressLine2,"addressLine2Error");
		let isCityValid = hasSpecialCharsOrWhitespace(city,"cityError");
		let isStateValid = hasSpecialCharsOrWhitespace(state,"stateError");
		let isAddressPhoneNumberValid = validatePhoneNumber(addressPhoneNumber,"addressPhoneNumberError");
		let isPincodeValid = validatePincode(pincode,"pincodeError");
		if(isAddressFirstNameValid &&
			isAddressLastNameValid &&
			isAddressLine1Valid &&
			isAddressLine2Valid &&
			isCityValid &&
			isStateValid &&
			isAddressPhoneNumberValid &&
			isPincodeValid
		){
			return true;
		}else{
			return false;
		}
	});

    $("#editProfileForm").submit(function(){
		let firstName= $("#firstName").val();
		let lastName= $("#lastName").val();
		let emailId= $("#emailId").val();
		let phoneNumber= $("#phoneNumber").val();
		let userId= $("#editProfile").val();

		let isFirstNameValid = hasSpecialCharsOrWhitespace(firstName,"firstNameError");
		let isLastNameValid = hasSpecialCharsOrWhitespace(lastName,"lastNameError");
		let isEmailValid = validateEmail(emailId,"emailError");
		let isPhoneValid = validatePhoneNumber(phoneNumber,"phoneNumberError");
		if(isFirstNameValid &&
			isLastNameValid &&
			isEmailValid &&
			isPhoneValid
		){
			$.ajax({
				type:"POST",
				url:"components/user.cfc?method=updateProfile",
				data:{
					userId:userId,
					firstName:firstName,
					lastName:lastName,
					emailId:emailId,
					phoneNumber:phoneNumber
				},
				success: function(result) {
					editProfileResult=JSON.parse(result)
					if(editProfileResult.success){

						$("#profileName").text(firstName +' '+lastName);
						$("#profileEmail").text(emailId);

						$("#firstName").attr("value",firstName);
						$("#lastName").attr("value",lastName);
						$("#emailId").attr("value",emailId);
						$("#phoneNumber").attr("value",phoneNumber);
						$("#profileBtn").text(firstName);
						$("#profileEditModal").modal("hide");
						Swal.fire({
							position: "top",
							toast: true,
							icon: "success",
							title: "Profile edited successfully",
							showConfirmButton: false,
							timer: 1500
						});
						$("#updateProfileError").text("");
					}else{
						if(editProfileResult.emailError){
							setError(message = editProfileResult.emailError,messageLocationId = "emailError")
						}
						if(editProfileResult.phoneError){
							setError(message = editProfileResult.phoneError,messageLocationId = "phoneNumberError")
						}
					}
					if(editProfileResult.error){
						$("#updateProfileError").text(editProfileResult.error);
					}
				},error: function(){
					alert("Error occured");
				}
			});
		}
		return false;
	});

    $(".deleteAddress").click(function(){
		const addressId=this.value;
		Swal.fire({
			title: "Are you sure?",
			text: "This address will be deleted from your profile!",
			icon: "warning",
			showCancelButton: true,
			confirmButtonColor: "#3085d6",
			cancelButtonColor: "#d33",
			confirmButtonText: "Delete"
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"components/user.cfc",
					data:{
						encryptedAddressId:addressId,
						method:"deleteAddress"
					},
					success: function(result) {
						logOutResult=JSON.parse(result)
						if(logOutResult.success){
							$("#address"+$.escapeSelector(addressId)).remove();
						}else{
							Swal.fire({
								title: "Error occured while deleting!",
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
	});
    
});

if(myModalElement = document.getElementById('profileEditModal')){
    myModalElement.addEventListener('hide.bs.modal', event => {
        $(".form-control").removeClass("is-valid")
        $(".form-control").removeClass("is-invalid")
        $(".errorMessage").text("")
    });
}

if(myModalElement = document.getElementById('addAddressModal')){
    myModalElement.addEventListener('hide.bs.modal', event => {
        $(".form-control").removeClass("is-valid")
        $(".form-control").removeClass("is-invalid")
        $(".errorMessage").text("")
    });
}