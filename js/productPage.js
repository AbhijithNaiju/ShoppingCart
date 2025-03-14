$(document).ready(function(){
    $("#buyNow").click(function(){
		productId=this.value;
		addToCart(productId,"order");
		location.href="./orderPage.cfm"
	});
});

function addToCart(productId,redirect){
    $.ajax({
        type:"POST",
        url:"components/cart.cfc?method=addToCart",
        data:{productId:productId},
        success: function(result) {
            addToCartResult=JSON.parse(result)
            if(addToCartResult.redirect){
                if(redirect && redirect==="order"){
                    location.href="login.cfm?redirect=order&productId="+encodeURIComponent(productId);
                }else{
                    location.href="login.cfm?redirect=cart&productId="+encodeURIComponent(productId);
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
                if(addToCartResult.cartCount){
                    $("#cartCount").text(addToCartResult.cartCount);
                }
            }
        },error: function(){
            alert("Error occured");
        }
    });
}