function loginValidate()
{
    
    let userName = $("#userName").val();
    let password = $("#password").val();
    $(".errorMessage").text("");
    error = false;
    if(!userName.trim().length)
    {
        $("#userNameError").text("Please enter email or phone number");
        error = true
    }
    if(!password.trim().length)
    {
        $("#passwordError").text("Please enter the password");
        error = true
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
		confirmButtonText: "Logout !"
	  }).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				type:"POST",
				url:"components/admin.cfc?method=logOut",
				success: function(result) {
					logOutResult=JSON.parse(result)
					if(logOutResult.success){
						location.reload();
					}
					else{
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

function openCategoryModal(categoryData)
{
    $("#addModal").removeClass("displayNone")
    if(categoryData.categoryId)
    {
        $("#modalHeading").text("Edit category");
        $("#modalCategorySubmit").val(categoryData.categoryId);
        $("#categoryName").val(categoryData.categoryName);
        $("#modalCategorySubmit").text("EDIT");

    }
    else
    {
        $("#modalHeading").text("Add category");
        $("#modalCategorySubmit").val(0);
        $("#modalCategorySubmit").text("ADD");
    }
}
function openSubCategoryModal(subCategoryData)
{
    $("#addModal").removeClass("displayNone")
    $("#categorySelect").val(subCategoryData.CategoryId);
    if(subCategoryData.subCategoryId)
    {
        $("#modalHeading").text("Edit Sub Category");
        $("#modalSubCatSubmit").val(subCategoryData.subCategoryId);
        $("#subCategoryName").val(subCategoryData.subCategoryName);
        $("#modalSubCatSubmit").text("EDIT");
    }
    else
    {
        $("#modalHeading").text("Add Sub Category");
        $("#modalSubCatSubmit").val(0);
        $("#modalSubCatSubmit").text("ADD");
    }
}
function openProductModal(productData)
{
    $("#addModal").removeClass("displayNone")
    $("#categorySelect").val(productData.categoryId);
    listSubcategories(productData.categoryId,productData.subCategoryId);
    if(productData.productId)
    {
        $("#modalHeading").text("Edit Product");
        $("#productId").val(productData.productId);
        $("#modalProductSubmit").text("EDIT");
        $("#productImages").removeAttr("required")
        $.ajax({
            type:"POST",
            url:"components/admin.cfc?method=getProductDetails",
            data:{productId:productData.productId},
            success: function(result) {
                if(result)
                {
                    productDetails=JSON.parse(result);
                    $("#brandSelect").val(productDetails.brandId);
                    $("#productName").val(productDetails.productName);
                    $("#productDescription").val(productDetails.productDescription);
                    $("#productPrice").val(productDetails.price);
                    $("#productTax").val(productDetails.tax);
                }
                else
                {
                    alert("Error occured");
                }
            },
            error:function()
            {
                alert("An error occured")
            }
        });
    }
    else
    {
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
            if(result)
            {
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
            }
            else
            {
                alert("Error occured while getting subcategory");
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}
function productSubmit()
{
    event.preventDefault();
    $("#modalError").text("");
    let isWrongExtention = false;
    var allowedExtentions = ['jpg', 'jpeg', 'bmp', 'gif', 'png', 'svg'];
    let imageList = document.getElementById("productImages");
    for (var i = 0; i < imageList.files.length; ++i) {
        var inputFileName = imageList.files.item(i).name;
        fileExtension = String(/[^.]+$/.exec(inputFileName));
        if(!allowedExtentions.includes(fileExtension.toLowerCase())){
            isWrongExtention = true;
            break;
        }
    }
    if(isWrongExtention){
        $("#modalError").text("Only jpg, jpeg, bmp, gif, png and svg files are allowed");
    }
    else{
        productData = new FormData(document.getElementById("modalForm"))
        $.ajax({
            type: "POST",
            url: "components/admin.cfc?method=addOrEditProduct",
            data: productData,
            processData: false,
            contentType: false,
            success: function(result) {
                resultJson=JSON.parse(result);
                if(resultJson.error){
                    $("#modalError").text(resultJson.error);
                }
                else
                {
                    closeModal();
                    location.reload();
                }
            }
        });
    }
    return false

}
function closeModal()
{
    $("#addModal").addClass("displayNone")
    $("#modalForm")[0].reset();
}

function  deleteCategory(categoryId)
{
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the category and its contents.!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete !"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteCategory",
                data:{categoryId:categoryId.value},
                success: function(result) {
                    if(result)
                    {
                        categoryId.parentElement.parentElement.remove();
                    }
                    else
                    {
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
function  deleteSubCategory(deleteButton)
{
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the sub category and its contents!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete !"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteSubCategory",
                data:{subCategoryId:deleteButton.value},
                success: function(result) {
                    if(result)
                    {
                        deleteButton.parentElement.parentElement.remove();
                    }
                    else
                    {
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
function  deleteProduct(deleteButton)
{
    Swal.fire({
        title: "Are you sure?",
        text: "This will delete the product and its contents!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Delete !"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type:"POST",
                url:"components/admin.cfc?method=deleteProduct",
                data:{productId:deleteButton.value},
                success: function(result) {
                    if(result)
                    {
                        $("#product"+deleteButton.value).remove();
                    }
                    else
                    {
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
function openImageModal(productData)
{
    $("#imageModal").removeClass("displayNone");
    listProductImages(productData.productId)
}
function listProductImages(productId)
{
    var carouselInner = document.getElementById("carouselInner");
    carouselInner.innerHTML="";
    $.ajax({
        type:"POST",
        url:"components/admin.cfc?method=getProductImages",
        data:{productId:productId},
        success: function(result) {
            if(result)
            {
                productImages=JSON.parse(result);

                defaultImageKey=Object.keys(productImages.defaultImage);
                let slideBody = `
                <div class="carousel-item active">
                    <img src="../assets/productImages/${productImages.defaultImage[defaultImageKey]}" class="d-block w-100">
                </div>`;
                $("#carouselInner").append(slideBody)
                
                if(productImages.remainingImages)
                {

                    const jsonKeys=Object.keys(productImages.remainingImages);
                    for(i=0;i<jsonKeys.length;i++)
                    {
                        remainingImageId=jsonKeys[i];
                        let slideBody = `
                        <div class="carousel-item">
                        <img src="../assets/productImages/${productImages.remainingImages[remainingImageId]}" class="d-block w-100">
                            <div class="carouselButtons">
                                <button onclick="deleteImage({productId:${productId},imageId:${remainingImageId}})" class="btn btn-danger">DELETE</button>
                                <button onclick="setDefaultImage({productId:${productId},imageId:${remainingImageId}})" class="btn btn-secondary text-nowrap">
                                    Make Default
                                </button>
                            </div>
                        </div>`;
                        $("#carouselInner").append(slideBody)
                        console.log()
                    }
                }
            }
            else
            {
                alert("Error occured while getting subcategory");
            }
        },
        error:function()
        {
            alert("An error occured");
        }
    });
}
function deleteImage(imageDetails)
{
    $.ajax({
        type:"POST",
        url:"components/admin.cfc?method=deleteImage",
        data:{imageId:imageDetails.imageId},
        success: function(result) {
            if(result)
            {
                listProductImages(imageDetails.productId)
                
            }
            else
            {
                alert("Error occured while deleteing");
            }
        },
        error:function()
        {
            alert("An error occured");
        }
    });
}
function setDefaultImage(imageDetails)
{
    $.ajax({
        type:"POST",
        url:"components/admin.cfc?method=setDefaultImage",
        data:{imageId:imageDetails.imageId,productId:imageDetails.productId},
        success: function(result) {
            if(result)
            {
                listProductImages(imageDetails.productId)
            }
            else
            {
                alert("Error occured while Setting default");
            }
        },
        error:function()
        {
            alert("An error occured");
        }
    });
}