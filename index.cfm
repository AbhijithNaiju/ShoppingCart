<cfinclude  template="./userHeader.cfm">
<cfset categories = application.userObject.getAllCategories()>
<cfset allSubcategories = application.userObject.getAllSubcategories()>
<cfset randomProducts = application.userObject.getRandomProducts()>
<cfoutput>
    <div class="categoryNav d-flex justify-content-around px-3">
        <cfloop query="categories">
            <div  class = "navCategory" >
                <a href="category.cfm?catId=#categories.categoryId#" class = "navCategoryName" >
                #categories.categoryName#
                </a>
                <cfquery  name = "subcategories" dbtype="query">
                SELECT 
                    *
                FROM
                    allSubcategories
                WHERE
                    categoryId = #categories.categoryId#
                </cfquery>
                <div class="categoryDropDown d-flex flex-column">
                    <cfloop query="subcategories">
                        <a href="productListing.cfm?subcatId=#subcategories.subcategoryId#" class="navSubcategoryName btn">
                            #subcategories.subcategoryName#
                        </a>
                    </cfloop>
                </div>
            </div>
        </cfloop>
    </div>
    <div class="">
        <h3>
            Random Products
        </h3>
        <div class="productListingParent m-3">
            <cfloop query = "randomProducts">
                <a 
                    href="product.cfm?productId=#randomProducts.productId#" 
                    class="randomProducts p-3 d-flex flex-column align-items-center border"
                >
                    <img src="./assets/productimages/#randomProducts.imageFileName#"></img>
                    <div class="w-100 my-2">
                        <h6>#randomProducts.productName#</h6>
                        <p>#randomProducts.brandName#</p>
                        <p class="mt-auto">Rs : #randomProducts.productPrice + randomProducts.productTax#</p>
                    </div>
                </a>
            </cfloop>
        </div>
    </div>
</cfoutput>
<cfinclude  template="./userFooter.cfm">