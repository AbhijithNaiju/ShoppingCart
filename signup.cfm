<cfset local.signupResult = structNew()>
<cfif structKeyExists(form,"signupButton")>
    <cfset local.signupResult = application.userObject.userSignp(
        firstName = form.firstName,
        lastName = form.lastName,
        emailId = form.emailId,
        phoneNumber = form.phoneNumber,
        password = form.password
        )>
    <cfif structKeyExists(local.signupResult,"success")>
        <cflocation url="index.cfm" addtoken="false">
    </cfif>
</cfif>

<cfinclude  template="userHeader.cfm">
<div class="mainBody">
    <form method="post" class="loginForm">
        <div class="formHeader">
            User Login
        </div>
        <div class="form-group">
            <label for="userName">First name</label>
            <input 
                type="text" 
                class="form-control" 
                id="firstName" 
                name="firstName" 
                placeholder="First name" 
                required
            >
        </div>
        <div class="form-group">
            <label for="userName">Last name</label>
            <input 
                type="text" 
                class="form-control" 
                id="lastName" 
                name="lastName" 
                placeholder="Last name" 
                required
            >
        </div>
        <div class="form-group">
            <label for="userName">Email Id</label>
            <input 
                type="email" 
                class="form-control" 
                id="emailId" 
                name="emailId" 
                placeholder="Email Id" 
                required
            >
        </div>
        <div class="form-group">
            <label for="userName">Phone</label>
            <input 
                type="tel" 
                class="form-control" 
                id="phoneNumber" 
                name="phoneNumber" 
                placeholder="Phone" 
                required
            >
        </div>
        <div class="form-group">
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
        <cfif structKeyExists(local, "signupResult") AND structKeyExists(local.signupResult, "error")>
            <cfoutput>
                <div class="errorMessage loginError">
                    #local.signupResult.error#
                </div>
            </cfoutput>
        </cfif>
        <input type="submit" id="" class="btn btn-success" name="signupButton">
    </form>
</div>
<cfinclude  template="userFooter.cfm">