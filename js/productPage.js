$(document).ready(function(){
    $("#buyNow").click(function(){
		productId=this.value;
		addToCart(productId=productId,redirect="order");
		location.href="./orderPage.cfm"
	});
});

function addToCart(productId,redirect){
    $.ajax({
        type:"POST",
        url:"components/cart.cfc",
        data:{
            productId:productId,
            method:"addToCart"
        },
        success: function(result) {
            addToCartResult=JSON.parse(result)
            if(addToCartResult.redirect){
                $("#addToCartId").val(productId);
                $("#loginModal").modal("show");
                if(redirect && redirect==="order"){
                    location.href="login.cfm?redirect=order&productId="+encodeURIComponent(productId);
                }else{
                    
                }
            }else{
                Swal.fire({
                    position: "top",
                    toast: true,
                    icon: "success",
                    title: "Product added to cart",
                    showConfirmButton: false,
                    timer: 1500
                });
                if(redirect && redirect==="order"){
                    location.href="order.cfm";
                }else{
                    location.href="cart.cfm";
                }
                if(addToCartResult.cartCount){
                    $("#cartCount").text(addToCartResult.cartCount);
                }
            }
        },error: function(){
            alert("Error occured");
        }
    });
}