<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/adminStyle.css">
        <title>Admin</title>
        <link rel="stylesheet" href="../style/bootstrap.min.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <div class="header bg-success">
            <a href="../admin/index.cfm" class="logo">
                <img src="../assets/Images/shopping cart_transparent.png">
            </a>
            <cfset excludedPages = ["/admin/login.cfm"]>
            
            <cfif NOT arrayFindNoCase(excludedPages, CGI.script_name)>
                <div class="logOutBtn">
                    <button class="" onclick="logOut()">
                        Logout
                    </button>
                    <img src="../assets/images/icons8-logOut-24.png" alt="image not found">
                </div>
            </cfif> 
        </div>