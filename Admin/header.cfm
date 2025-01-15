<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/adminStyle.css">
        <link rel="stylesheet" href="../style/bootstrap.min.css">
        <title>Admin</title>
    </head>
    <body>
        <div class="header bg-success">
            <a href="../index.cfm" class="logo">
                <img src="../admin/assets/Images/shopping cart_transparent.png">
            </a>
            <cfset excludedPages = ["login.cfm"]>
            <cfset currentTemplate = listLast(CGI.script_name ,'/')>
            
            <cfif NOT arrayFindNoCase(excludedPages, currentTemplate)>
                <div class="logOutBtn">
                    <button class="" onclick="logout()">
                        Logout
                    </button>
                    <img src="./assets/images/icons8-logout-24.png" alt="image not found">
                </div>
            </cfif> 
        </div>