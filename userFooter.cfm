        <div class="modal fade" tabindex="-1" id="loginModal" data-bs-backdrop="static">
            <form class="modal-dialog modal-dialog-centered" id="loginModalForm" method="">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Please login to continue</h5>
                        <button type="reset" class="btn-close closeProfileEdit" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div>
                        <div class="m-4">
                            <div class="form-group my-2">
                                <label for="modalUserName">User name *</label>
                                <input 
                                    type="text" 
                                    class="form-control" 
                                    id="modalUserName" 
                                    name="modalUserName"
                                >
                                <div class = "errorMessage" id="modalUserNameError"></div>
                            </div>
                            <div class="form-group my-2">
                                <label for="modalPassword">Password *</label>
                                <input 
                                    type="password" 
                                    class="form-control" 
                                    id="modalPassword" 
                                    name="modalPassword"
                                    autocomplete="false"
                                >
                                <div class = "errorMessage" id="modalPasswordError"></div>
                            </div>
                        </div>
                    </div>
                    <div class = "text-center errorMessage" id="loginModalError"></div>
                    <div class = "text-center text-success" id=""></div>
                    <div class="modal-footer">
                        <button 
                            type="reset" 
                            class="btn btn-secondary m-2 closeProfileEdit" 
                            data-bs-dismiss="modal"
                        >
                            Close
                        </button>
                        <button 
                            type="button" 
                            id="modalLoginBtn"
                            class="btn btn-primary m-2"
                        >
                            Login
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <!--- bootstrap version 5.3.3 --->
        <script src="./js/sweetalert2.all.min.js"></script>
        <script src="./js/bootstrap.bundle.min.js"></script>
        <script src="./js/jquery-3.7.1.js"></script>
        <script src="./js/validation.js"></script>
        <cfif CGI.script_name  EQ "/product.cfm">
            <script src="./js/productPage.js"></script>
        </cfif>
        <script src="./js/common.js"></script>
    </body>
</html>