<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../style/bootstrap.min.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="style/user.css">
        <title>Shopping Cart</title>
    </head>
    <body>
        <cfset variables.excludedPages = ["/login.cfm","/missingpage.cfm","/errorpage.cfm","/signup.cfm"]>
        <div class="header bg-success">
            <a href="../index.cfm" class="logo">
                <img src="../assets/Images/shopping cart_transparent.png">
            </a>
            
            <cfif NOT arrayFindNoCase(variables.excludedPages, CGI.script_name)>
                <div class="searchBar">
                    <form class="input-group" action="productlisting.cfm">
                        <input 
                            type="text" 
                            class="form-control" 
                            name="searchValue" 
                            placeholder="" 
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
                    <button id="profileBtn">
                        Profile
                    </button>
                    <div class="cartButton">
                        <button id="cartBtn">
                            Cart
                        </button>
                        <span class="badge" id="cartCount"></span>
                    </div>
                    <button  id="logOutBtn">
                        Login
                    </button>
                </div>
            </cfif> 
        </div>
        <cfif NOT arrayFindNoCase(variables.excludedPages, CGI.script_name)>
            <cfset variables.allSubcategories = application.userObject.getAllSubcategories()>
            <div class="categoryNav px-3 py-1 border">
                <cfoutput query="variables.allSubcategories" group="categoryId">
                    <div  class = "navCategory" >
                        <a href="category.cfm?catId=#variables.allSubcategories.categoryId#" class = "navCategoryName" >
                            #variables.allSubcategories.categoryName#
                        </a>
                        <cfquery  name = "variables.subcategories" dbtype="query">
                            SELECT 
                                subcategoryId,
                                subcategoryName
                            FROM
                                allSubcategories
                            WHERE
                                categoryId = #variables.allSubcategories.categoryId#
                                AND subcategoryId IS NOT NULL
                        </cfquery>
                        <div class="categoryDropDown d-flex flex-column ">
                            <cfloop query="variables.subcategories">
                                <a 
                                    href="productListing.cfm?subcatId=#variables.subcategories.subcategoryId#" 
                                    class="navSubcategoryName btn border"
                                >
                                    #variables.subcategories.subcategoryName#
                                </a>
                            </cfloop>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </cfif>