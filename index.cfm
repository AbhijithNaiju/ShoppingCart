<cfinclude  template="./userHeader.cfm">
<cfset categories = application.userObject.getAllCategories()>
<cfset subcategories = application.userObject.getAllSubcategories()>
<cfset randomProducts = application.userObject.getRandomProducts()>
<div class="categoryNav d-flex justify-content-around">
    <cfoutput>
            <cfloop query="categories">
                <div  class = "navCategory" >
                    <a href="category.cfm?catId=#categories.categoryId#" class = "navCategoryName" >
                    #categories.categoryName#
                    </a>
                    <div class="categoryDropDown d-flex flex-column">
                        <cfloop query="subcategories">
                            <cfif categories.categoryId EQ subcategories.categoryId>
                                <a href="subcategory.cfm" class="navSubcategoryName btn btn-outline-dark">
                                    #subcategories.subcategoryName#
                                </a>
                            </cfif>
                        </cfloop>
                    </div>
                </div>
            </cfloop>
    </div>
    <div class="h-50 border-dark">
        <h1>
            Random Products
        </h1>
        <div class="d-flex flex-wrap m-2 justify-content-around">
            <cfloop query = "randomProducts">
                <a 
                    href="product.cfm?proId=#randomProducts.productId#" 
                    class="randomProducts border border-dark m-2 p-2 d-flex flex-column align-items-center"
                >
                    <img src="./assets/productimages/#randomProducts.imageFileName#"></img>
                    <h6>#randomProducts.productName#</h6>
                    <p>#randomProducts.brandName#</p>
                    <!-- add price -->
                </a>
            </cfloop>
        </div>
    </div>
    <div id="loginModal" class="displayNone">
        <form id="loginForm" class="categoryModalBody mx-auto p-3 d-flex flex-column">
            <h4 id="modalHeading"></h4>
            <div class="form-group">
                <label for="userName">
                    Username
                </label>
                <input type="text" id="userName" name="userName" class="form-control my-3" required>
            </div>
            <div class="form-group">
                <label for="password">
                    Password
                </label>
                <input type="text" id="password" name="password" class="form-control my-3" required>
            </div>
            <div class="d-flex justify-content-around mt-auto">
                <button 
                    type="button" 
                    class="btn btn-secondary w-50 mx-1" 
                    onclick="closeLoginModal()"
                >
                    Close
                </button>
                <button 
                    class="btn btn-success w-50 mx-1" 
                    id="modalCategorySubmit" 
                    name = "modalCategorySubmit"
                >
                    Login
                </button>
            </div>
        </form>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">