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
        <div class="header bg-success">
            <a href="../admin/index.cfm" class="logo">
                <img src="../admin/Assets/Images/shopping cart_transparent.png">
            </a>
            <cfset headerRequired = ["index.cfm","subcategory.cfm","product.cfm"]>
            <cfset currentTemplate = listLast(CGI.PATH_TRANSLATED,'\')>
            <cfif arrayFindNoCase(headerRequired, currentTemplate)>
                <div class="logOutBtn">
                    <button class="" onclick="logout()">
                        Logout
                    </button>
                    <img src="./Assets/Images/icons8-logout-24.png" alt="">
                </div>
            </cfif> 
        </div>