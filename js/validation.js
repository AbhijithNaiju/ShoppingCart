function validatePhoneNumber(phoneNumber,messageLocationId) {
    const regex = /^(\+?[0-9-]{8,15})$/;
    if(regex.test(phoneNumber)){
        setSuccess(messageLocationId)
        return true;
    }else{
        setError(message = "Please enter a valid phone number",messageLocationId = messageLocationId)
        return false
    }
}
function validatePincode(pincode,messageLocationId) {
    const regex =  /^[0-9]{6}$/;
    if(regex.test(pincode)){
        setSuccess(messageLocationId)
        return true;
    }else{
        setError(message = "Please enter a valid pincode",messageLocationId = messageLocationId)
        return false
    }
}
  
function validateEmail(email,messageLocationId) {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if(regex.test(email)){
        setSuccess(messageLocationId);
        return true;
    }else{
        setError(message = "Please Enter a valid email",messageLocationId = messageLocationId)
        return false
    }
}
function validatePassword(password,messageLocationId){
    const match_space=/\s/;
    if(match_space.test(password)){
        setError(message = "Password should not contain any special character",messageLocationId = messageLocationId)
        return false
    }else if(password.length<8){
        setError(message = "Password needs to be at least 8 characters long.",messageLocationId = messageLocationId)
        return false
    }else{
        setSuccess(messageLocationId);
        return true;
    }
}
function confirmPasswords(password1,password2,messageLocationId){
    if(password2.trim().length){
        if(password1 == password2){
            setSuccess(messageLocationId);
            return true;
        }else{
            setError(message = "Passwords do not match",messageLocationId = messageLocationId)
            return false
        }
    }else{
        setError(message = "Please fill this field",messageLocationId = messageLocationId)
        return false;
    }
}
function hasSpecialCharsOrWhitespace(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9]/;
    if(input.trim().length){
        if(regexMatchSpecial.test(input)){
            setError(
                message = "This field should not contain any special character or whitespace",
                messageLocationId = messageLocationId
            )
            return false;
        }else if(input.trim().length){
            setSuccess(messageLocationId);
            return true;
        }
    }else{
        setError(message = "Please fill out this field",messageLocationId = messageLocationId)
        return false;
    }
}

function checkSpecialCharacter(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9-\s\+]/;
    if(regexMatchSpecial.test(input)){
        setError(message = "This field should not contain any special character",messageLocationId = messageLocationId)
        return false;
    }else{
        if(input.trim().length){
        setSuccess(messageLocationId)
        }
        return true;
    }
}
function checkProductName(input,messageLocationId){
    const regexMatchSpecial=/[^a-zA-Z0-9.\s&/()"%-+,\[\]\*\$]/;
    if(regexMatchSpecial.test(input)){
        setError(message = "This field should not contain any special character",messageLocationId = messageLocationId)
        return false;
    }else{
        if(input.trim().length){
        setSuccess(messageLocationId)
        }
        return true;
    }
}
function setError(message,messageLocationId){
    $("#"+messageLocationId).text(message);
    $("#"+messageLocationId).prev().addClass("is-invalid").removeClass("is-valid");
    $("#"+messageLocationId).prev().focus();
}
function setSuccess(messageLocationId){
    $("#"+messageLocationId).text("")
    $("#"+messageLocationId).prev().addClass("is-valid").removeClass("is-invalid");
}
