<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/user.css">
        <link rel="stylesheet" href="./style/bootstrap.min.css">
        <title>Shopping Cart</title>
    </head>
    <body>
        <div class="header bg-success">
            <a href="../index.cfm" class="logo">
                <img src="../assets/Images/shopping cart_transparent.png">
            </a>
            <cfset logOutRequired = ["index.cfm"]>
            <cfset currentTemplate = listLast(CGI.PATH_TRANSLATED,'\')>
            <cfif arrayFindNoCase(logOutRequired, currentTemplate)>
                <div class="logOutBtn">
                    <button class="" onclick="logout()">
                        Logout
                    </button>
                    <img src="./assets/Images/icons8-logout-24.png" alt="">
                </div>
            </cfif> 
        </div>