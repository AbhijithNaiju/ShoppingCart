<div class="header bg-success">
    <a href="#" class="logo">
        <img src="../admin/Assets/Images/shopping cart_transparent.png">
    </a>
    <cfset headerRequired = ["index.cfm","subcategory.cfm"]>
    <cfif arrayFindNoCase(headerRequired, currentTemplate)>
        <div class="logOutBtn">
            <button class="" onclick="logout()">
                Logout
            </button>
            <img src="./Assets/Images/icons8-logout-24.png" alt="">
        </div>
    </cfif>
</div>