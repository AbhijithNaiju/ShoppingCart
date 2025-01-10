<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../Style/admin.css">
        <link rel="stylesheet" href="../Style/bootstrap.min.css">
        <title>Document</title>
    </head>
    <body>
        <cfset adminObject = createObject("component","components.admin")>
        <div class="header">
            <a href="#" class="logo">
                <img src="../Assets/Images/SHOPPING CART_transparent-.png">
            </a>
            <!-- <button class="logOutBtn">
                Logout
            </button> -->
        </div>
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
        <script src="./JS/jquery-3.7.1.js"></script>
        <script src="./JS/admin.js"></script>
    </body>
</html>