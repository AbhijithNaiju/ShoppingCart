<cfset local.loginResult = structNew()>
<cfif structKeyExists(form,"loginBtn")>
    <cfset local.loginResult = application.userObject.userLogin(
        username = form.userName,
        password = form.password
        )>
    <cfif structKeyExists(local.loginResult,"success")>
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
            <label for="userName">User name</label>
            <input type="text" class="form-control" id="userName" name="userName" placeholder="Username" required>
            <span class="errorMessage"></span>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
            <span class="errorMessage"></span>
        </div>
        <cfif structKeyExists(local, "loginResult") AND structKeyExists(local.loginResult, "error")>
            <cfoutput>
                <div class="errorMessage loginError">
                    #local.loginResult.error#
                </div>
            </cfoutput>
        </cfif>
        <input type="submit" id="" class="btn btn-success" name="loginBtn">
        <div class="d-flex my-2">
            Dont have an account ? 
            <a href="./signup.cfm">Signup</a>
        </div>
    </form>
</div>
<cfinclude  template="userFooter.cfm">