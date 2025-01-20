function logout(){
	if(confirm("You will log out of this page and need to authenticate again to login"))
	{
		$.ajax({
			type:"POST",
			url:"components/user.cfc?method=logOut",
			success: function() {
				location.reload();
			}
		});
	}
}

// function openLoginModal(){
// 	$("#loginModal").removeClass("displayNone")
// }

// function closeLoginModal(){
// 	$("#loginModal").addClass("displayNone")
//     $("#modalForm")[0].reset();
// }

function userLogin(){
	$.ajax({
		type:"POST",
		url:"components/user.cfc?method=userLogin",
		success: function() {
			
		}
	});
}
