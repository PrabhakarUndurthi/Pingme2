
window.userFriendship = [];

$(document).ready(function(){

$.ajax ({
	url: Routes.user_friendship_path({format: 'json'}),
	dataType: 'json',
	type: 'GET',
	success: function(data) {
		window.userFriendship = data;

	}

});


	$('#add-friendship').click(function(event){
		event.preventDefault();
		var addFriendshipBtn = $(this);
		$.ajax({
			url: Routes.user_friendship_path({user_friendship: {friend_id: addFriendshipBtn.data('friendId')}}),
			dataType: 'json',
			type: 'POST',
			success: function(e){
				addFriendshipBtn.hide();
				$('#friend-status').html("<a href= '#' class='btn-success'>Friendship Requested</a>");




			}
		});

	});
});