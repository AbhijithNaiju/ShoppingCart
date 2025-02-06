<cfinclude  template="userHeader.cfm">

<cfif structKeyExists(form,"editProfile")>
    <cfset variables.editProfileResult = application.userObject.updateProfile(
        userId = session.userId,
        formStruct = form
    )>
</cfif>
<cfif structKeyExists(form,"addAddress")>
    <cfset variables.addAddressResult = application.userObject.addAddress(
        userId = session.userId,
        formStruct = form
    )>
</cfif>
<cfset variables.profileDetails=application.userObject.getProfileDetails(userId=session.userId)>
<cfset variables.addressList=application.userObject.getAddressListDetails(userId=session.userId)>
<cfoutput>
    <div class="profileBody container border w-50 h-100 d-flex flex-column">
        <div class="profileHeader d-flex justify-content-between align-items-center mx-2">
            <div class="profileDetails">
                Hello,
                <span class="m-1 profileName">
                    #variables.profileDetails.firstName & ' ' & variables.profileDetails.LastName#
                </span>
                <p>#variables.profileDetails.email#</p>
            </div>
            <button class="btn btn-primary btn-sm" id="openProfileEdit">Edit</button>
        </div>
        <cfif structKeyExists(variables,"editProfileResult") and structKeyExists(variables.editProfileResult, "error")>
            <div class = "text-center errorMessage">#variables.editProfileResult.error#</div>
        </cfif>
        <cfif structKeyExists(variables,"addAddressResult") and structKeyExists(variables.addAddressResult, "error")>
            <div class = "text-center errorMessage">#variables.addAddressResult.error#</div>
        </cfif>
        <h2 class = "addressHeading">Addresses</h2>
        <div class="addressBody border overflow-scroll">
            <cfloop array="#variables.addressList#" item="variables.addressItem">
                <div class = "border p-3 d-flex justify-content-between align-items-center" id="address#variables.addressItem.addressId#">
                    <div class="d-flex flex-column">
                        <span class="addressName">#variables.addressItem.firstName & ' ' & variables.addressItem.lastName#</span>
                        <span>
                            #variables.addressItem.addressLine1 & ', '#
                            <cfif structKeyExists(variables.addressItem,"addressLine2")>
                                #variables.addressItem.addressLine2 & ', '#
                            </cfif>
                            #variables.addressItem.city & ', '#
                            #variables.addressItem.state & ', '#
                            #variables.addressItem.pincode#
                        </span>
                        <span>#variables.addressItem.phoneNumber#</span>
                    </div>
                    <button 
                        class = "btn btn-danger btn-sm deleteAddress" 
                        value="#variables.addressItem.addressId#"
                    >
                        Delete
                    </button>
                </div>
            </cfloop>
        </div>
        <div class="profileFooter d-flex">
            <button class="w-50 btn m-1 btn-success" id="addAddress">Add Address</button>
            <a href="./orderHistory.cfm" class="w-50 btn m-1 border border-success">Order History</a>
        </div>
    </div>
    <div id="profileModal" class="displayNone">
        <div class="displayNone" id="profileEditBody">
            <form class="profileModalBody" method="post">
                <div class="m-4">
                    <div class="form-group my-2">
                        <label for="firstName">First Name</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        id="firstName" 
                        name="firstName"
                        value="#variables.profileDetails.firstName#"
                        required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="lastName">Last Name</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="lastName" 
                            name="lastName"
                            value="#variables.profileDetails.lastName#"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="emailId">Email Address</label>
                        <input 
                            type="email" 
                            class="form-control" 
                            id="emailId" 
                            name="emailId"
                            value="#variables.profileDetails.email#"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="phoneNumber">Phone Number</label>
                        <input 
                            type="tel" 
                            class="form-control" 
                            id="phoneNumber" 
                            name="phoneNumber"
                            minlength="8"
                            maxlength="15"
                            pattern="[0-9]{10}"
                            value="#variables.profileDetails.phone#"
                            required
                        >
                    </div>
                </div>
                <div class="editFooter w-100 d-flex">
                    <button type="reset" class="btn btn-secondary m-2 w-50 closeProfileEdit">Close</button>
                    <button type="submit" name="editProfile" class="btn btn-primary m-2 w-50">Edit</button>
                </div>
            </form>
        </div>
        <div class="displayNone" id="addAddressBody">
            <form method="post" class = "profileModalBody overflow-scroll">
                <div class="m-4">
                    <div class="form-group my-2">
                        <label for="">First Name</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        name="firstName"
                        required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Last Name</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="lastName"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 1</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine1"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 2</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine2"
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">City</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="city"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">State</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="state"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Phone Number</label>
                        <input 
                            type="tel" 
                            class="form-control"  
                            name="phoneNumber"
                            minlength="8"
                            maxlength="15"
                            pattern="[0-9-]"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Pincode</label>
                        <input 
                            type="tel" 
                            class="form-control" 
                            name="pincode"
                            minlength="6"
                            maxlength="6"
                            pattern="[0-9]{6}"
                            required
                        >
                    </div>
                </div>
                <div class="addressFooter w-100 d-flex bg-white">
                    <button type="reset" class="btn btn-secondary m-2 w-50 closeProfileEdit">Close</button>
                    <button type="submit" class="btn btn-primary m-2 w-50" name = "addAddress">Add</button>
                </div>
            </form>
        </div>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">