<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/adminStyle.css">
        <link rel="stylesheet" href="../style/bootstrap.min.css">
        <title>Document</title>
    </head>
    <body>
        <cfset currentTemplate = listLast(GetCurrentTemplatePath(),'\')>
        <cfinclude  template="./header.cfm">
        <div class="mainBody">
            <form method="post" class="loginForm" onSubmit="return loginValidate()">
                <div class="formHeader">
                    Admin Login
                </div>
                <div class="form-group">
                    <label for="userName">User name</label>
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="Username">
                    <span class="errorMessage" id ="userNameError"></span>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                    <span class="errorMessage" id ="passwordError"></span>
                </div>
                <input type="submit" id="" class="btn btn-success" name="submitBtn">
                
                <cfif structKeyExists(form,"submitBtn")>
                    <cfset adminObject = createObject("component","components.admin")>
                    <cfset local.loginResult = adminObject.adminLogin(
                        username = form.userName,
                        password = form.password
                        )>
                        <cfif structKeyExists(local, "loginResult") AND structKeyExists(local.loginResult, "error")>
                            <cfoutput>
                                <div class="errorMessage loginError">
                                    #local.loginResult.error#
                                </div>
                            </cfoutput>
                        </cfif>
                    </cfif>
                </form>
        </div>
        <script src="../js/jquery-3.7.1.js"></script>
        <script src="./js/admin.js"></script>
    </body>
</html>