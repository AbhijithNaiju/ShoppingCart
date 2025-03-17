<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/x-icon" href="../assets/images/flaticon.png">
        <link rel="stylesheet" href="../style/bootstrap.min.css">
        <link rel="stylesheet" href="../style/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="style/adminStyle.css">
        <title>Shopping Cart</title>
    </head>
    <body>
        <div class="header bg-success">
            <a href="./index.cfm" class="logo">
                <img src="../assets/Images/shopping cart_transparent.png">
            </a>
            <cfset excludedPages = ["/admin/login.cfm"]>
            <cfif NOT arrayFindNoCase(excludedPages, CGI.script_name)>
                <div class="logOutBtn">
                    <button onclick="logOut()">
                        Logout
                    </button>
                    <img src="../assets/images/icons8-logOut-24.png" alt="image not found">
                </div>
            </cfif> 
        </div>