<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/x-icon" href="assets/images/flaticon.png">
        <link rel="stylesheet" href="style/bootstrap.min.css">
        <link rel="stylesheet" href="style/sweetalert2.min.css">
        <link rel="stylesheet" href="style/fontawesome/css/all.min.css">
        <link rel="stylesheet" href="style/user.css">
        <title>Shopping Cart</title>
    </head>
    <body>
        <cfset variables.excludedPages = ["/login.cfm","/missingpage.cfm","/signup.cfm"]>
        <div class = "header">
            <div class="headerLinks bg-success">
                <a href="../index.cfm" class="logo">
                    <img src="../assets/Images/shopping cart_transparent.png">
                </a>
                
                <cfif NOT arrayFindNoCase(variables.excludedPages, CGI.script_name)>
                    <div class="searchBar">
                        <form class="d-flex" action="productlisting.cfm">
                            <input 
                                type="text" 
                                class="form-control form-control-sm me-2" 
                                name="searchValue" 
                                placeholder="Search products" 
                                aria-label="Search" 
                                aria-describedby="basic-addon2"
                                required
                            >
                            <div>
                                <button class="btn btn-sm btn-outline-light" type="submit">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                    <cfif structKeyExists(session, "userSession") AND structKeyExists(session.userSession, "userId")>
                        <cfoutput>
                            <div class="menuButtonContainer">
                                <div>
                                    <a id="profileBtn"
                                        <cfif CGI.script_name EQ "/profilePage.cfm">
                                            class="menuButton"
                                        <cfelse>
                                            class="menuButton" 
                                            href="./profilePage.cfm" 
                                        </cfif>
                                    >
                                        #session.userSession.name#
                                    </a>
                                </div>
                                <div>
                                    <a 
                                        id="cartBtn" 
                                        <cfif CGI.script_name EQ "/cartPage.cfm">
                                            class="menuButton"
                                        <cfelse>
                                            class="menuButton" 
                                            href="./cartPage.cfm" 
                                        </cfif>
                                    >
                                        Cart
                                    </a>
                                    <span 
                                        class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark"
                                        id="cartCount"
                                    >
                                        #session.userSession.cartCount#
                                    </span>
                                </div>
                                <div class="menuButton">
                                    <button id="logOutBtn" class="me-1">
                                        Logout 
                                    </button>
                                    <img 
                                        src="assets/images/icons8-logOut-24.png" 
                                        alt="image not found"
                                        class = "logoutImage"
                                    >
                                </div>
                            </div>
                        </cfoutput>
                    <cfelse>
                        <div class="menuButtonContainer">
                            <div>
                                <a id="profileBtn" class = "menuButton" href="./login.cfm?redirect=profilePage">Profile </a>
                            </div>
                            <div>
                                <a id="cartBtn" class = "menuButton" href="./login.cfm?redirect=cart">Cart </a>
                            </div>
                            <div>
                                <a class="menuButton" href="login.cfm">Login </a>
                            </div>
                        </div>
                    </cfif>
                </cfif>
            </div>
            <cfif NOT arrayFindNoCase(variables.excludedPages, CGI.script_name)>
                <cfset variables.allSubcategories = application.productObject.getSubcategories()>
                <div class="categoryNav px-3 py-1">
                    <cfoutput query="variables.allSubcategories" group="categoryId">
                        <cfset variables.categoryId = urlEncodedFormat(application.userObject.encryptID(variables.allSubcategories.categoryId))>
                        <div class = "navCategory">
                            <a href="category.cfm?categoryId=#variables.categoryId#" class = "navCategoryName">
                                #variables.allSubcategories.categoryName#
                            </a>
                            <div class="categoryDropDown dropdown-menu d-flex flex-column ">
                                <cfoutput>
                                    <cfset variables.subcategoryId = urlEncodedFormat(application.userObject.encryptId(variables.allSubcategories.subcategoryId))>
                                    <li>
                                        <a 
                                            href="productListing.cfm?subcategoryId=#variables.subcategoryId#" 
                                            class="navSubcategoryName dropdown-item py-2 btn"
                                        >
                                            #variables.allSubcategories.subcategoryName#
                                        </a>
                                    </li>
                                </cfoutput>
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cfif>
        </div>