<cfset variables.loginResult = structNew()>
<cfif structKeyExists(form,"loginBtn")>
    <cfset variables.loginResult = application.userObject.userLogin(
        username = form.userName,
        password = form.password
    )>
    <cfif structKeyExists(variables.loginResult,"success")>
        <!--- Login is success --->
        <cfif structKeyExists(url, "redirect")>
            <!--- redirect is present in url --->
            
            <cfif structKeyExists(url, "productId") AND isNumeric(url.productId)>
                <!--- product id is present in url --->

                <cfif url.redirect EQ "cart" OR url.redirect EQ "order">
                    <!--- adding product to cart and going back to product page --->
                    <cfset addTocart = application.userObject.addToCart(url.productId)>
                    <cfif url.redirect EQ "order">
                        <!--- goto to order page --->
                        <cflocation  url="./orderPage.cfm" addtoken="no">
                    <cfelse>
                        <cflocation  url="./product.cfm?productId=#url.productId#" addtoken="no">
                    </cfif>
                </cfif>

            <cfelseif url.redirect EQ "cart">
                <!--- go to cart page(productid is not present) --->
                <cflocation  url="./cartPage.cfm" addtoken="no">

            <cfelseif url.redirect EQ "profilePage">
                <!--- go to cart page(productid is not present) --->
                <cflocation  url="./profilePage.cfm" addtoken="no">
                
            </cfif>

        <cfelse>
            <!--- goto home page(no redirect value) --->
            <cflocation url="index.cfm" addtoken="false">
        </cfif>
    </cfif>
</cfif>

<cfinclude  template="userHeader.cfm">
<div class="mainBody">
    <form method="post" class="loginForm">
        <div class="formHeader">
            User Login
        </div>
        <div class="form-group my-3">
            <label for="userName">User name</label>
            <input type="text" class="form-control" id="userName" name="userName" placeholder="Username" required>
            <span class="errorMessage"></span>
        </div>
        <div class="form-group my-3">
            <label for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
            <span class="errorMessage"></span>
        </div>
        <cfif structKeyExists(variables, "loginResult") AND structKeyExists(variables.loginResult, "error")>
            <cfoutput>
                <div class="errorMessage loginError">
                    #variables.loginResult.error#
                </div>
            </cfoutput>
        </cfif>
        <input type="submit" id="" class="btn btn-success" name="loginBtn" value="Submit">
        <div class="d-flex my-2">
            Dont have an account ? 
            <a href="./signup.cfm" class = "mx-1" >Signup</a>
        </div>
    </form>
</div>
<cfinclude  template="userFooter.cfm">