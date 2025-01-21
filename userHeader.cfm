<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="style/user.css">
        <link rel="stylesheet" href="../style/bootstrap.min.css">
        <title>Shopping Cart</title>
    </head>
    <body>
        <div class="header bg-success">
            <a href="../index.cfm" class="logo">
                <img src="../assets/Images/shopping cart_transparent.png">
            </a>
            <cfset excludedPages = ["/login.cfm","/missingpage.cfm","/errorpage.cfm","/signup.cfm"]>
            
            <cfif NOT arrayFindNoCase(excludedPages, CGI.script_name)>
                <div class="searchBar">
                    <form class="input-group" action="productlisting.cfm">
                        <input 
                            type="text" 
                            class="form-control" 
                            name="searchValue" 
                            placeholder="Search" 
                            aria-label="Search" 
                            aria-describedby="basic-addon2"
                            required
                        >
                        <div class="input-group-append">
                            <button class="btn  btn-outline-light" type="submit">Search</button>
                        </div>
                    </form>
                </div>
                    <div class="menuButtons">
                    <button>
                        Profile
                    </button>
                    <button>
                        Cart
                    </button>
                    <cfif structKeyExists(session, "userId")>
                            <button onclick="logout()">
                                Logout
                            </button>
                            <img src="./assets/images/icons8-logout-24.png" alt="image not found">
                    <cfelse>
                            <a href="./login.cfm">
                                Login
                            </a>
                    </cfif>
                </div>
            </cfif> 
        </div>