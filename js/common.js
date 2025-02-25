function validatePhoneNumber(phoneNumber,messageLocationId) {
    const regex = /^(\+?[0-9-]{8,15})$/;
    if(regex.test(phoneNumber)){
        setSuccess(messageLocationId)
        return true;
    }else{
        setError("Please enter a valid phone number",messageLocationId)
        return false
    }
}
function validatePincode(pincode,messageLocationId) {
    const regex =  /^[0-9]{6}$/;
    if(regex.test(pincode)){
        setSuccess(messageLocationId)
        return true;
    }else{
        setError("Please enter a valid pincode",messageLocationId)
        return false
    }
}
  
function validateEmail(email,messageLocationId) {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if(regex.test(email)){
        setSuccess(messageLocationId);
        return true;
    }else{
        setError("Please Enter a valid email",messageLocationId)
        return false
    }
}
function validatePassword(password,messageLocationId){
    const match_space=/\s/;
    if(match_space.test(password)){
        setError("Password should not contain any special character",messageLocationId)
        return false
    }else if(password.length<8){
        setError("Password needs to be at least 8 characters long.",messageLocationId)
        return false
    }else{
        setSuccess(messageLocationId);
        return true;
    }
}
function confirmPasswords(password1,password2,messageLocationId){
    if(password1 == password2){
        setSuccess(messageLocationId);
        return true;
    }else{
        setError("Passwords do not match",messageLocationId)
        return false
    }
}
function hasSpecialCharsOrWhitespace(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9]/;
    if(regexMatchSpecial.test(input)){
        setError("This field should not contain any special character or whitespace",messageLocationId)
        return false;
    }else if(input.trim().length){
        setSuccess(messageLocationId);
        return true;
    }
}

function checkSpecialCharacter(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9-\s\+]/;
    if(regexMatchSpecial.test(input)){
        setError("This field should not contain any special character",messageLocationId)
        return false;
    }else if(input.trim().length){
        setSuccess(messageLocationId)
        return true;
    }
}
function setError(message,messageLocationId){
    $("#"+messageLocationId).text(message);
    $("#"+messageLocationId).prev().addClass("is-invalid").removeClass("is-valid");
}
function setSuccess(messageLocationId){
    $("#"+messageLocationId).text("")
    $("#"+messageLocationId).prev().addClass("is-valid").removeClass("is-invalid");
}
