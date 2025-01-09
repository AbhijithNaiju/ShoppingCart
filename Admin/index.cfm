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
        <div class="header bg-success">
            <a href="#" class="logo">
                <img src="../Assets/Images/shopping cart_transparent.png">
            </a>
            <div class="logOutBtn">
                <button class="" onclick="logout()">
                    Logout
                </button>
                <img src="../Assets/Images/icons8-logout-24.png" alt="">
            </div>
        </div>
        <div class="mainBody">
            
        </div>
        <script src="./JS/jquery-3.7.1.js"></script>
        <script src="./JS/admin.js"></script>
    </body>
</html>