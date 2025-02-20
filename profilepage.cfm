<cfinclude  template="userHeader.cfm">

<cfif structKeyExists(form,"addAddress")>
    <cfset variables.addAddressResult = application.userObject.addAddress(
        userId = session.userSession.userId,
        formStruct = form
    )>
</cfif>
<cfset variables.profileDetails=application.userObject.getProfileDetails(userId=session.userSession.userId)>
<cfset variables.addressList=application.userObject.getAddressList(userId=session.userSession.userId)>
<cfoutput>
    <div class="profileBody container w-50 h-100 d-flex flex-column my-3 shadow p-3 bg-body">
        <div class="profileHeader d-flex justify-content-between align-items-center mx-2">
            <div class="profileDetails">
                Hello,
                <span class="m-1 profileName" id="profileName">
                    #variables.profileDetails.firstName & ' ' & variables.profileDetails.LastName#
                </span>
                <p id="profileEmail">#variables.profileDetails.email#</p>
            </div>
            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="##profileEditModal">
                <img src="./assets/images/edit-icon-white.png">
            </button>
        </div>
        <cfif structKeyExists(variables,"addAddressResult") and structKeyExists(variables.addAddressResult, "error")>
            <div class = "text-center errorMessage">#variables.addAddressResult.error#</div>
        </cfif>
        <h2>Addresses</h2>
        <div class="addressBody mb-2">
            <cfloop array="#variables.addressList#" item="variables.addressItem">
                <div 
                    class = "border rounded-1 p-3 my-2 d-flex justify-content-between align-items-center" 
                    id="address#variables.addressItem.addressId#"
                >
                    <div class="d-flex flex-column">
                        <span class="addressName">#variables.addressItem.firstName & ' ' & variables.addressItem.lastName#</span>
                        <span>
                            #variables.addressItem.addressLine1 & ', '#
                            <cfif structKeyExists(variables.addressItem,"addressLine2") AND LEN(variables.addressItem.addressLine2)>
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
                        <img src="./assets/images/delete-white.png">
                    </button>
                </div>
            </cfloop>
        </div>
        <div class="profileFooter d-flex">
            <button type="button" class="btn btn-outline-primary w-50 m-1" data-bs-toggle="modal" data-bs-target="##addAddressModal">
                Add Address
            </button>
            <a href="./orderHistory.cfm" class="w-50 btn m-1 btn-outline-primary">Order History</a>
        </div>
    </div>
    <div class="modal fade" tabindex="-1" id="addAddressModal" data-bs-backdrop="static">
        <form method="post" class = "modal-dialog modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add address</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group my-2">
                        <label for="">First Name *</label>
                    <input 
                        type="text" 
                        class="form-control" 
                        name="firstName"
                        required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Last Name *</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="lastName"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 1 *</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine1"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Address Line 2 *</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="addressLine2"
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">City *</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="city"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">State *</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            name="state"
                            required
                        >
                    </div>
                    <div class="form-group my-2">
                        <label for="">Phone Number *</label>
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
                        <label for="">Pincode *</label>
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
                <div class="modal-footer">
                    <button type="reset" class="btn btn-secondary m-2 closeProfileEdit" data-bs-dismiss="modal">
                        Close
                    </button>
                    <button type="submit" class="btn btn-primary m-2" name = "addAddress">Add</button>
                </div>
            </div>
        </form>
    </div>
    <div class="modal fade" tabindex="-1" id="profileEditModal" data-bs-backdrop="static">
        <form class="profileModalBody modal-dialog" id="editProfileForm" method="post">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Profile</h5>
                    <button type="button" class="btn-close closeProfileEdit" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div>
                    <div class="m-4">
                        <div class="form-group my-2">
                            <label for="firstName">First Name *</label>
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
                            <label for="lastName">Last Name *</label>
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
                            <label for="emailId">Email Address *</label>
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
                            <label for="phoneNumber">Phone Number *</label>
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
                </div>
                <div class = "text-center errorMessage" id="updateProfileError"></div>
                <div class = "text-center text-success" id="updateProfileSuccess"></div>
                <div class="modal-footer">
                    <button 
                        type="reset" 
                        class="btn btn-secondary m-2 closeProfileEdit" 
                        data-bs-dismiss="modal"
                    >
                        Close
                    </button>
                    <button 
                        type="submit" 
                        id="editProfile" 
                        value="#session.userSession.userId#" 
                        name="editProfile" 
                        class="btn btn-primary m-2"
                    >
                        Edit
                    </button>
                </div>
            </div>
        </form>
    </div>
</cfoutput>
<cfinclude  template="userFooter.cfm">