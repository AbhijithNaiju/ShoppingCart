let defaultImage;
let deletedProducts=[];
$(document).ready(function(){
    $("#modalCategorySubmit").click(function(){
        let categoryName= $("#categoryName").val();
        let categoryId= $("#modalCategorySubmit").val();
		let isCategoryNameValid = checkSpecialCharacter(categoryName,"categoryNameError");
		if(isCategoryNameValid){
            $.ajax({
                type:"post",
                url:"components/admin.cfc",
                data:{
                    categoryName:categoryName,
                    categoryId:categoryId,
                    method:"editCategory"
                },
                success:function(result){
                    resultJson=JSON.parse(result);
                    if(resultJson.success){
                        if(resultJson.edit){
                            $("#categoryItem"+categoryId).find(".categoryName").text(categoryName);
                            Swal.fire({
                                position: "top",
                                toast: true,
                                icon: "success",
                                title: "Category edited successfully",
                                showConfirmButton: false,
                                timer: 1500
                            });
                        }else if(resultJson.create){
                            let categoryItem=`
                                <div 
                                    class="categoryItem d-flex justify-content-between align-items-center my-1"
                                    id="categoryItem${resultJson.categoryId}"
                                >
                                    <div class = "categoryName">${categoryName}</div>
                                    <div class="d-flex justify-content-between categoryButtons">
                                        <button 
                                            type="button" 
                                            class="btn btn-sm" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#addModal"
                                            onclick="openCategoryModal(${resultJson.categoryId})"
                                        >
                                            <img src="../assets/images/edit-icon.png">
                                        </button>
                                        <button 
                                            class="btn btn-sm" 
                                            onclick="deleteCategory(this)" 
                                            value="${resultJson.categoryId}">
                                            <img src="../assets/images/delete-icon.png">
                                        </button>
                                        <a 
                                        href="subcategory.cfm?categoryId=${resultJson.categoryId}" 
                                        class="btn btn-sm">
                                        <img src="../assets/images/open-icon.png">
                                        </a>
                                    </div>
                                </div>
                            `
                            $("#categoryList").append(categoryItem);
                            Swal.fire({
                                position: "top",
                                toast: true,
                                icon: "success",
                                title: "Category created successfully",
                                showConfirmButton: false,
                                timer: 1500
                            });
                        }
                        if($("#categoryList").children().length){
                            $("#noCategoryError").text("");
                        }else{
                            $("#noCategoryError").text("No Subcategory Found");
                        }
                        $("#addModal").modal("hide");
                        $("#categoryName").val("");
                    }else if(resultJson.error){
                        setError(resultJson.error,"categoryNameError")
                    }else{
                        alert("Unexpected error occured")
                    }
                },error:function(){
                    alert("Error occured");
                }
            });
        }

    });
    $("#modalSubCatSubmit").click(function(){
        let categoryId= $("#categorySelect").val();
        let subcategoryName= $("#subCategoryName").val();
        let currentCategoryId= $("#currentCategoryId").val();
        let subcategoryId= $("#modalSubCatSubmit").val();
		let isSubcategoryNameValid = checkSpecialCharacter(subcategoryName,"modalError");
		if(isSubcategoryNameValid){
            $.ajax({
                type:"post",
                url:"components/admin.cfc",
                data:{
                    categoryId:categoryId,
                    subcategoryName:subcategoryName,
                    subCategoryId:subcategoryId,
                    method:"editSubCategory"
                },
                success:function(result){
                    resultJson=JSON.parse(result);
                    if(resultJson.success){
                        if(resultJson.edit){
                            if(currentCategoryId == categoryId){
                                $("#subCategory"+subcategoryId).find(".subcategoryName").text(subcategoryName);
                            }else{
                                $("#subCategory"+subcategoryId).remove();
                            }
                            Swal.fire({
                                position: "top",
                                toast: true,
                                icon: "success",
                                title: "Subcategory edited successfully",
                                showConfirmButton: false,
                                timer: 1500
                            });
                        }else if(resultJson.create){
                            let subcategoryItem=`
                                <div 
                                    class="categoryItem d-flex justify-content-between align-items-center my-1"
                                    id="subCategory${resultJson.subcategoryId}"
                                >
                                    <div class = "categoryName">${subcategoryName}</div>
                                    <div class="d-flex justify-content-between categoryButtons">
                                        <button 
                                            type="button" 
                                            class="btn btn-sm" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#addModal"
                                            onclick="openSubCategoryModal(${categoryId},${resultJson.subcategoryId})"
                                        >
                                            <img src="../assets/images/edit-icon.png">
                                        </button>
                                        <button 
                                            class="btn btn-sm" 
                                            onclick="deleteSubCategory(this)" 
                                            value="${resultJson.subcategoryId}">
                                            <img src="../assets/images/delete-icon.png">
                                        </button>
                                    <a 
                                        href="product.cfm?subCategoryId=${resultJson.subcategoryId}"
                                        class="btn btn-sm">
                                        <img src="../assets/images/open-icon.png">
                                    </a>
                                    </div>
                                </div>
                            `;
                            $("#subcategoryList").append(subcategoryItem);
                            Swal.fire({
                                position: "top",
                                toast: true,
                                icon: "success",
                                title: "Subcategory created successfully",
                                showConfirmButton: false,
                                timer: 1500
                            });
                        }
                        if($("#subcategoryList").children().length){
                            $("#noSubcategoryError").text("");
                        }else{
                            $("#noSubcategoryError").text("No Subcategory Found");
                        }
                        $("#subCategoryName").val("");
                        $("#addModal").modal("hide");
                    }else if(resultJson.error){
                        setError(resultJson.error,"modalError");
                    }else{
                        alert("Unexpected error occured");
                    }
                },error:function(){
                    alert("Error occured");
                }
            });
        }else{
            return false;
        }
    });
    $("#productModalForm").submit(function(){
        let productName= $("#productName").val();
        let productTax= $("#productTax").val();
        let isProductTaxValid = false;
        if(parseFloat(productTax)>100){
            setError("Please enter a valid tax percentage","productTaxError")
            isProductTaxValid =false;
        }else{
            setSuccess("productTaxError")
            isProductTaxValid =true;
        }
		let isproductNameValid = checkProductName(productName,"productNameError");
        $("#modalError").text("");
        let isWrongExtention = false;
        var allowedExtentions = ['jpg', 'jpeg', 'bmp', 'gif', 'png', 'svg'];
        let imageList = document.getElementById("productImages");
        for (var i = 0; i < imageList.files.length; ++i){
            var inputFileName = imageList.files.item(i).name;
            fileExtension = String(/[^.]+$/.exec(inputFileName));
            if(!allowedExtentions.includes(fileExtension.toLowerCase())){
                isWrongExtention = true;
                break;
            }
        }
        if(isWrongExtention){
            setError("Only jpg, jpeg, bmp, gif, png and svg files are allowed","productImageError")
        }else if(isproductNameValid && isProductTaxValid){
            productData = new FormData(document.getElementById("productModalForm"))
            if(defaultImage != null){
                productData.append("defaultImage",defaultImage);
            }
            if(deletedProducts != []){
                productData.append("deletedProducts",deletedProducts.toString());
            }
            $.ajax({
                type: "POST",
                url: "components/admin.cfc?method=addOrEditProduct",
                data: productData,
                processData: false,
                contentType: false,
                success: function(result) {
                    resultJson=JSON.parse(result);
                    if(resultJson.error){
                        $("#productNameError").text(resultJson.error);
                    }
                    else if(resultJson.success){
                        if(resultJson.isSameCategoryID){
                            if(resultJson.edit){
                                $("#product"+resultJson.productDetails.productId).find(".productName").text(resultJson.productDetails.ProductName);
                                $("#product"+resultJson.productDetails.productId).find(".brandName").text(resultJson.productDetails.ProductBrand);
                                $("#product"+resultJson.productDetails.productId).find(".productPrice").text(resultJson.productDetails.totalPrice);
                            }else if(resultJson.insert){
                                let productDiv=`
                                    <div 
                                        class="productItem my-2 rounded border shadow-sm p-3 justify-content-between align-items-center"
                                        id="product${resultJson.productDetails.productId}"
                                    >
                                        <div class="row">
                                            <div 
                                                class="d-flex col-4" 
                                            >
                                                <img
                                                    src="../assets/productimages/${resultJson.productDetails.defaultImage}" 
                                                    alt="Image not found" 
                                                    class="thumbnailImage">
                                            </div>
                                            <div class="col-6 d-flex flex-column">
                                                <div class="productName">${resultJson.productDetails.ProductName}</div>
                                                <div class="brandName">${resultJson.productDetails.ProductBrand}</div>
                                                <div class = "mt-auto">
                                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                                    ${resultJson.productDetails.totalPrice}
                                                </div>
                                            </div>
                                            <div class="col-2 d-flex flex-column justify-content-around">
                                                <button 
                                                    type="button" 
                                                    class="productButtons" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#addModal"
                                                    onclick="openProductModal({categoryId:${resultJson.productDetails.categoryId},subCategoryId:${resultJson.productDetails.subcategoryId},productId:${resultJson.productDetails.productId}})"
                                                    value="${resultJson.productDetails.productId}"
                                                >
                                                    <img src="../assets/images/edit-icon.png">
                                                </button>
                                                <button 
                                                    class="productButtons" 
                                                    onclick="deleteProduct(this)" 
                                                    value="${resultJson.productDetails.productId}"
                                                >
                                                    <img src="../assets/images/delete-icon.png">
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                `;
                                $('#productList').append(productDiv);
                            }
                        }else{
                            $("#product"+resultJson.productDetails.productId).remove();
                        }
                        $("#addModal").modal("hide");
                        imageList.value=null;

                        if($("#productList").children().length){
                            $("#noProductError").text("");
                        }else{
                            $("#noProductError").text("No Products Found");
                        }
                    }else if(resultJson.productNameError){
                        setError(resultJson.productNameError,"productNameError");
                    }else if(resultJson.productTaxError){
                        setError(resultJson.productTaxError,"productTaxError");
                    }else{
                        alert("Unexpected error occured please try again");
                    }
                }
            });
        }
        return false
    });

    if(myModalElement = document.getElementById('addModal')){
        myModalElement.addEventListener('hide.bs.modal', event => {
            $(".form-control").removeClass("is-valid is-invalid");
            $(".errorMessage").text("");
            $("#editImageBody").empty();
        });
    }
    $("#productImages").change(function(){
        editImageBody=$("#editImageBody");
        $(".addedImages").remove();
        for (var i = 0; i < this.files.length; ++i){
            var reader = new FileReader();
            let inputFile = this.files.item(i);
            let inputFileName = inputFile.name;

            reader.onload = function(event) {
                imageItem = `
                    <div class="col-2 d-flex flex-column addedImages">
                        <div class="editImage my-1 d-flex">
                            <img 
                                src="${event.target.result}" 
                                class="d-block p-1 m-auto"
                            >
                            <button 
                                type="button"
                                class="deleteImage"
                                title="Delete"
                                onclick="removeImage(this,'${inputFileName}')"
                            >
                                <i class="fa-solid fa-trash"></i>   
                            </button>
                        </div>
                    </div>
                `;
                editImageBody.append(imageItem);
            };
            reader.readAsDataURL(inputFile);
        }
    });
});
function removeImage(item,inputFileName){
    item.parentElement.parentElement.remove();
    const fileInput = document.getElementById('productImages');
    const files = Array.from(fileInput.files);
    const updatedFiles = [];
    for (let i = 0; i < files.length; i++) {
        if (files[i].name !== inputFileName) {
            updatedFiles.push(files[i]);
        }
    }
    const dataTransfer = new DataTransfer();
    updatedFiles.forEach(file => dataTransfer.items.add(file));
    fileInput.files = dataTransfer.files;
}
function loginValidate(){
    
    let userName = $("#userName").val();
    let password = $("#password").val();
    $(".errorMessage").text("");
    error = false;
    if(!userName.trim().length){
        setError("Please enter email or phone number","userNameError");
        error = true
    }else{
        setSuccess("userNameError");
    }
    if(!password.trim().length){
        setError("Please enter the password","passwordError")
        error = true
    }else{
        setSuccess("passwordError");
    }
    if(error)
        return false
}
function logOut(){
	Swal.fire({
		title: "Are you sure?",
		text: "You will log out of this page and need to authenticate again to login",
		icon: "warning",
		showCancelButton: true,
		confirmButtonColor: "#3085d6",
		cancelButtonColor: "#d33",
		confirmButtonText: "Logout"
	  }).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				type:"POST",
				url:"components/admin.cfc?method=logOut",
				success: function(result) {
					logOutResult=JSON.parse(result)
					if(logOutResult.success){
						location.reload();
					}else{
						Swal.fire({
							title: "Error!",
							text: "Please try again.",
							icon: "error"
						  });
					}
				},error: function(){
					alert("Error occured");
				}
			});
		}
	});
}

function openCategoryModal(categoryId){
    if(categoryId){
        $.ajax({
            type:"post",
            url:"components/admin.cfc",
            data:{
                categoryId:categoryId,
                method:"getCategoryname"
            },
            success:function(result){
                resultJson=JSON.parse(result);
                if(resultJson.success){
                    $("#categoryName").val(resultJson.categoryName);
                }else if(resultJson.error){
                    alert(resultJson.error);
                }else{
                    alert("Unexpected error occured")
                }
            },error:function(){
                alert("Error occured");
            }
        });
        $("#modalHeading").text("Edit category");
        $("#modalCategorySubmit").val(categoryId);
        $("#modalCategorySubmit").text("EDIT");
    }else{
        $("#modalHeading").text("Add category");
        $("#modalCategorySubmit").val(0);
        $("#modalCategorySubmit").text("ADD");
    }
}
function openSubCategoryModal(categoryId,subcategoryId){
    $("#categorySelect").val(categoryId);
    if(subcategoryId){
        $.ajax({
            type:"post",
            url:"components/admin.cfc",
            data:{
                subcategoryId:subcategoryId,
                method:"getSubcategories"
            },
            success:function(result){
                resultJson=JSON.parse(result);
                if(resultJson.length == 1){
                    $("#subCategoryName").val(resultJson[0].subcategoryName);
                    $("#modalSubCatSubmit").val(subcategoryId);
                }else{
                    alert("Unexpected error occured")
                }
            },error:function(){
                alert("Error occured");
            }
        });
        $("#modalHeading").text("Edit sub category");
        $("#modalSubCatSubmit").text("EDIT");
    }else{
        $("#modalHeading").text("Add Sub Category");
        $("#modalSubCatSubmit").val(0);
        $("#modalSubCatSubmit").text("ADD");
    }
}
function openProductModal(productData){
    defaultImage=null;
    deletedProducts=[];
    $("#categorySelect").val(productData.categoryId);
    listSubcategories(productData.categoryId,productData.subCategoryId);
    if(productData.productId){
        $("#modalHeading").text("Edit Product");
        $("#productId").val(productData.productId);
        $("#modalProductSubmit").text("EDIT");
        $("#productImages").removeAttr("required")
        $.ajax({
            type:"POST",
            url:"components/admin.cfc?method=getProductDetails",
            data:{productId:productData.productId},
            success: function(result) {
                resultJson=JSON.parse(result);
                if(resultJson.success){
                    $("#brandSelect").val(resultJson.productDetails.brandId);
                    $("#productName").val(resultJson.productDetails.productName);
                    $("#productDescription").val(resultJson.productDetails.productDescription);
                    $("#productPrice").val(resultJson.productDetails.price);
                    $("#productTax").val(resultJson.productDetails.tax);

                    // setting product images
                    if(resultJson.imageList){
                        resultJson.imageList.forEach(imageDetails => {
                            if(imageDetails.isDefaultImage == 1){
                                imageItem = `
                                    <div 
                                        class="col-2 d-flex flex-column imageItem currentDefaultImage" 
                                        id="imageItem${imageDetails.imageId}"
                                    >
                                        <div class="editImage my-1 d-flex">
                                            <img 
                                                src="../assets/productImages/${imageDetails.imageFileName}" 
                                                class="m-auto p-1 editModalImage"
                                            >
                                            <button 
                                                type="button"
                                                onclick="deleteImage(this,{productId:${productData.productId},imageId:${imageDetails.imageId}})" 
                                                class="deleteImage"
                                                title="Delete"
                                            >
                                                <i class="fa-solid fa-trash"></i>   
                                            </button>
                                        </div>
                                        <div class="d-flex mt-auto">
                                            <button 
                                                type="button" 
                                                name="setDefault" 
                                                class="m-auto btn btn-sm setDefaultBtn disabled"
                                                onclick="setDefaultImage(${productData.productId},${imageDetails.imageId})"
                                            >
                                                Default
                                            </button>
                                        </div>
                                    </div>
                                `;
                            }else{
                                imageItem = `
                                    <div class="col-2 d-flex flex-column imageItem" id="imageItem${imageDetails.imageId}">
                                        <div class="editImage my-1 d-flex">
                                            <img 
                                                src="../assets/productImages/${imageDetails.imageFileName}" 
                                                class="m-auto p-1 editModalImage"
                                            >
                                            <button 
                                                type="button"
                                                onclick="deleteImage(this,{productId:${productData.productId},imageId:${imageDetails.imageId}})" 
                                                class="deleteImage"
                                                title="Delete"
                                            >
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                        <div class="d-flex mt-auto">
                                            <button 
                                                type="button" 
                                                name="setDefault" 
                                                class="m-auto btn btn-sm setDefaultBtn"
                                                onclick="setDefaultImage(${productData.productId},${imageDetails.imageId})"
                                            >
                                                Set default
                                            </button>
                                        </div>
                                    </div>`;
                            }
                            $("#editImageBody").append(imageItem);
                        });
                    }
                }else{
                    alert("Error occured please try again");
                }
            },
            error:function(){
                alert("An error occured")
            }
        });
    }else{
        $("#modalHeading").text("Add Product");
        $("#productId").val(0);
        $("#modalProductSubmit").text("ADD");
        $("#productImages").attr("required","required");
    }
}
function listSubcategories(categoryId,currentSubCategoryId)
{
    $("#subCategorySelect").empty();
    $.ajax({
        type:"POST",
        url:"components/admin.cfc?method=getSubcategories",
        data:{categoryId:categoryId},
        success: function(result) {
            if(result){
                subCategoryDetails=JSON.parse(result);
                subCategoryDetails.forEach(element => {
                    var optionObj = document.createElement('option');
                    optionObj.innerHTML=element.subcategoryName;
                    optionObj.value=element.subcategoryId;
                    document.getElementById("subCategorySelect").appendChild(optionObj);

                    if(currentSubCategoryId)
                        $("#subCategorySelect").val(currentSubCategoryId);
                    else
                        $("#subCategorySelect").val(0);
                });
            }else{
                alert("Error occured while getting subcategory");
            }
        },
        error:function(){
            alert("An error occured")
        }
    });
}

function  deleteCategory(categoryId){
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the category and its contents.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete"
    }).then((result) => {
        if (result.isConfirmed){
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteCategory",
                data:{categoryId:categoryId.value},
                success: function(result) {
                    if(result){
                        categoryId.parentElement.parentElement.remove();
                        if($("#categoryList").children().length){
                            $("#noCategoryError").text("");
                        }else{
                            $("#noCategoryError").text("No Subcategory Found");
                        }
                    }else{
                        alert("Error occured while deleteing");
                    }
                },
                error:function()
                {
                    alert("An error occured");
                }
            });
        }
    });
}
function  deleteSubCategory(deleteButton){
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the sub category and its contents",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete"
    }).then((result) => {
        if (result.isConfirmed){
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteSubCategory",
                data:{subCategoryId:deleteButton.value},
                success: function(result) {
                    if(result){
                        deleteButton.parentElement.parentElement.remove();
                        if($("#subcategoryList").children().length){
                            $("#noSubcategoryError").text("");
                        }else{
                            $("#noSubcategoryError").text("No Subcategory Found");
                        }
                    }else{
                        alert("Error occured while deleteing");
                    }
                },
                error:function(){
                    alert("An error occured");
                }
            });
        }
    });
}
function  deleteProduct(deleteButton){
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the product and its contents",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete"
    }).then((result) => {
        if (result.isConfirmed){
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteProduct",
                data:{productId:deleteButton.value},
                success: function(result) {
                    if(result){
                        $("#product"+deleteButton.value).remove();
                        if($("#productList").children().length){
                            $("#noProductError").text("");
                        }else{
                            $("#noProductError").text("No Products Found");
                        }
                    }else{
                        alert("Error occured while deleteing");
                    }
                },
                error:function()
                {
                    alert("An error occured");
                }
            });
        }
    });
}
function deleteImage(item,imageDetails){
    deletedProducts.push(imageDetails.imageId);
    // $.ajax({
    //     type:"POST",
    //     url:"components/admin.cfc?method=deleteImage",
    //     data:{imageId:imageDetails.imageId},
    //     success: function(result) {
    //         resultJson=JSON.parse(result);
    //         if(resultJson.success){
                item.parentElement.parentElement.remove();
                
    //         }else{
    //             alert("Error occured while deleteing");
    //         }
    //     },
    //     error:function(){
    //         alert("An error occured");
    //     }
    // });
}
function setDefaultImage(productId,imageId){
    defaultImage = imageId;
    // $.ajax({
    //     type:"POST",
    //     url:"components/admin.cfc?method=setDefaultImage",
    //     data:{imageId:imageId,productId:productId},
    //     success: function(result) {
    //         resultJson=JSON.parse(result);
    //         if(resultJson.success){
                newSrc=$("#imageItem"+imageId).find(".editModalImage").attr("src");
                $("#product"+productId).find(".thumbnailImage").attr("src",newSrc);
                $(".currentDefaultImage").find(".setDefaultBtn").removeClass("disabled");
                $(".currentDefaultImage").find(".setDefaultBtn").text("Set default");
                $(".currentDefaultImage").removeClass("currentDefaultImage");
                $("#imageItem"+imageId).addClass("currentDefaultImage");
                $(".currentDefaultImage").find(".setDefaultBtn").addClass("disabled");
                $("#imageItem"+imageId).find(".setDefaultBtn").text("Default");
    //         }else if(!resultJson.error){
    //             alert("Unexpected error occured");
    //         }
    //     },
    //     error:function(){
    //         alert("An error occured");
    //     }
    // });
}