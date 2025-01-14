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
function logout()
{
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"./components/admin.cfc?method=logOut",
			success: function() {
				location.reload();
			}
		});
	}
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
            url:"./components/admin.cfc?method=getProductDetails",
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
function listSubcategories(categoryId,subCategoryId)
{
    $("#subCategorySelect").empty();
    $.ajax({
        type:"POST",
        url:"./components/admin.cfc?method=getSubcategories",
        data:{categoryId:categoryId},
        success: function(result) {
            if(result)
            {
                subContactDetails=JSON.parse(result);
                const jsonKeys=Object.keys(subContactDetails);
                for(i=0;i<jsonKeys.length;i++)
                {
                    subContactId=jsonKeys[i];
                    var optionObj = document.createElement('option');
                    optionObj.innerHTML=subContactDetails[subContactId];
                    optionObj.value=subContactId;
                    document.getElementById("subCategorySelect").appendChild(optionObj);

                    if(subCategoryId)
                        $("#subCategorySelect").val(subCategoryId);
                    else
                        $("#subCategorySelect").val(0);

                }
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
    productData = new FormData(document.getElementById("modalForm"))
    $.ajax({
        type: "POST",
        url: "./components/admin.cfc?method=addOrEditProduct",
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
    return false

}
function closeModal()
{
    $("#addModal").addClass("displayNone")
    $("#modalForm")[0].reset();
}

function  deleteCategory(categoryId)
{
    if(confirm("This will delete the category and its contents. Confirm delete?"))
    {
        $.ajax({
            type:"POST",
            url:"./components/admin.cfc?method=deleteCategory",
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
                alert("An error occured")
            }
        });
    }
}
function  deleteSubCategory(deleteButton)
{
    if(confirm("This will delete the sub category and its contents. Confirm delete?"))
    {
        $.ajax({
            type:"POST",
            url:"./components/admin.cfc?method=deleteSubCategory",
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
                alert("An error occured")
            }
        });
    }
}
function  deleteProduct(deleteButton)
{
    if(confirm("This will delete the sub category and its contents. Confirm delete?"))
    {
        $.ajax({
            type:"POST",
            url:"./components/admin.cfc?method=deleteProduct",
            data:{productId:deleteButton.value},
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
                alert("An error occured")
            }
        });
    }
}
function openImageModal(productData)
{
    $("#imageModal").removeClass("displayNone");
    listProductImages(productData.productId)
}
function closeImageModal()
{
    $("#imageModal").addClass("displayNone");
}
function listProductImages(productId)
{
    $.ajax({
        type:"POST",
        url:"./components/admin.cfc?method=getProductImages",
        data:{productId:productId},
        success: function(result) {
            if(result)
            {
                productImages=JSON.parse(result);
                const jsonKeys=Object.keys(productImages);
                active=1;
                for(i=0;i<jsonKeys.length;i++)
                {
                    imageId=jsonKeys[i];
                    var slideBody = document.createElement('div');
                    slideBody.classList.add("carousel-item");

                    var slideImage = document.createElement('img');
                    slideImage.classList.add("d-block");
                    slideImage.classList.add("w-100");
                    slideImage.src="../assets/productImages/"+productImages[imageId]
                    slideBody.appendChild(slideImage);
                    if(active)
                    {
                        slideBody.classList.add("active");
                        active=0;
                    }
                    else
                    {
                        // const buttonParent = `
                        // <div>
                        //     <button value='${imageId}' class="btn btn-danger">DELETE</button>
                        //     <button value='${imageId}' class="btn btn-success">Make Default</button>
                        // </div>`;
                        deleteButton=document.createElement('button');
                        deleteButton.value=imageId
                        deleteButton.classList.add("btn");
                        deleteButton.classList.add("btn-danger");
                        deleteButton.innerHTML="DELETE"
                        deleteButton.setAttribute("onclick","deleteImage(this)")

                        makeDefault=document.createElement('button');
                        makeDefault.value=imageId
                        makeDefault.classList.add("btn");
                        makeDefault.classList.add("btn-success");
                        makeDefault.innerHTML="Make Default"
                        makeDefault.setAttribute("onclick","setDefaultImage(this)")

                        buttonParent=document.createElement('div');
                        buttonParent.classList.add("carouselButtons");
                        buttonParent.appendChild(deleteButton);
                        buttonParent.appendChild(makeDefault);

                        slideBody.appendChild(buttonParent);

                    }
                    document.getElementById("carouselInner").appendChild(slideBody);
                    console.log(slideBody)
                }
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
function deleteImage(imageId)
{
    $.ajax({
        type:"POST",
        url:"./components/admin.cfc?method=deleteImage",
        data:{imageId:imageId.value},
        success: function(result) {
            if(result)
            {
                imageId.parentElement.parentElement.remove();
                location.reload()
            }
            else
            {
                alert("Error occured while deleteing");
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}
function setDefaultImage(imageId)
{
    $.ajax({
        type:"POST",
        url:"./components/admin.cfc?method=setDefaultImage",
        data:{imageId:imageId.value},
        success: function(result) {
            if(result)
            {
                alert("success")
            }
            else
            {
                alert("Error occured while deleteing");
            }
        },
        error:function()
        {
            alert("An error occured")
        }
    });
}