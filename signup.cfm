<cfset variables.signupResult = structNew()>
<cfif structKeyExists(form,"signupButton")>
    <cfset variables.signupResult = application.userObject.userSignup(
        firstName = form.firstName,
        lastName = form.lastName,
        emailId = form.emailId,
        phoneNumber = form.phoneNumber,
        password = form.password
    )>
    <cfif structKeyExists(variables.signupResult,"success")>
        <cflocation url="index.cfm" addtoken="false">
    </cfif>
</cfif>

<cfinclude  template="userHeader.cfm">
<div class="mainBody">
    <form method="post" class="loginForm">
        <div class="formHeader">
            User Login
        </div>
        <div class="form-group my-2">
            <label for="firstName">First name</label>
            <input 
                type="text" 
                class="form-control" 
                id="firstName" 
                name="firstName" 
                placeholder="First name" 
                required
            >
        </div>
        <div class="form-group my-2">
            <label for="lastName">Last name</label>
            <input 
                type="text" 
                class="form-control" 
                id="lastName" 
                name="lastName" 
                placeholder="Last name" 
                required
            >
        </div>
        <div class="form-group my-2">
            <label for="emailId">Email Id</label>
            <input 
                type="email" 
                class="form-control" 
                id="emailId" 
                name="emailId" 
                placeholder="Email Id" 
                required
            >
        </div>
        <div class="form-group my-2">
            <label for="phoneNumber">Phone</label>
            <input 
                type="tel" 
                class="form-control" 
                id="phoneNumber" 
                name="phoneNumber" 
                placeholder="Phone"
                maxlength="15"
                required
            >
        </div>
        <div class="form-group my-2">
            <label for="password">Password</label>
            <input 
                type="password" 
                class="form-control" 
                id="password" 
                name="password" 
                placeholder="Password" 
                minlength="8"
                required
            >
        </div>
        <cfif structKeyExists(variables, "signupResult") AND structKeyExists(variables.signupResult, "error")>
            <cfoutput>
                <div class="errorMessage loginError">
                    #variables.signupResult.error#
                </div>
            </cfoutput>
        </cfif>
        <input type="submit" id="" class="btn btn-success" name="signupButton" value="Submit">
        <div class="d-flex my-2">
            Already have an account ? 
            <a href="./login.cfm" class = "mx-1" >Login</a>
        </div>
    </form>
</div>
<cfinclude  template="userFooter.cfm">