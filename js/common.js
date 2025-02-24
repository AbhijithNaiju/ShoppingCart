function validatePhoneNumber(phoneNumber,messageLocationId) {
    const regex = /^(\+?[0-9-]{8,15})$/;
    if(regex.test(phoneNumber)){
        $("#"+messageLocationId).text("")
        return true;
    }else{
        $("#"+messageLocationId).text("Please enter a valid phone number")
        return false
    }
}
function validatePincode(pincode,messageLocationId) {
    const regex =  /^[0-9]{6}$/;
    if(regex.test(pincode)){
        $("#"+messageLocationId).text("")
        return true;
    }else{
        $("#"+messageLocationId).text("Please enter a valid pincode")
        return false
    }
}
  
function validateEmail(email,messageLocationId) {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if(regex.test(email)){
        $("#"+messageLocationId).text("");
        return true;
    }else{
        $("#"+messageLocationId).text("Please Enter a valid email");
        return false
    }
}
function validatePassword(password,messageLocationId){
    const match_space=/\s/;
    if(match_space.test(password)){
        $("#"+messageLocationId).text("Password should not contain any special character");
        return false
    }else if(password.length<8){
            $("#"+messageLocationId).text("Password needs to be at least 8 characters long.");
    }else{
        $("#"+messageLocationId).text("");
        return true;
    }
}
function confirmPasswords(password1,password2,messageLocationId){
    if(password1 == password2){
        $("#"+messageLocationId).text("");
        return true;
    }else{
        $("#"+messageLocationId).text("Passwords do not match");
        return false
    }
}
function hasSpecialCharsOrWhitespace(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9]/;
    if(regexMatchSpecial.test(input)){
        $("#"+messageLocationId).text("This field should not contain any special character or whitespace")
        return false;
    }else{
        $("#"+messageLocationId).text("")
        return true;
    }
}

function checkSpecialCharacter(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9\s]/;
    if(regexMatchSpecial.test(input)){
        $("#"+messageLocationId).text("This field should not contain any special character or whitespace")
        return false;
    }else{
        $("#"+messageLocationId).text("")
        return true;
    }
}