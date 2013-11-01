require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)
	  test "that creating a friendship works without raising an exception ."do 
	   assert_nothing_raised do
	   UserFriendship.create user: users(:prabhakar), friend: users(:zuke)
     end	
	end

	test "that creating a friendship  based on user id and friend id  works ."do 
	UserFriendship.create user: users(:prabhakar), friend: users(:zuke)
	assert users(:prabhakar).pending_friends.include?(users(:zuke))
   end


#If someone sends  friend request ,it would  create an instance .
   context "a new instance"do
     setup do
     	@user_friendship = UserFriendship.new user: users(:prabhakar),friend: users(:zuke)
     end

    #Once the new instance has been created , then it would be in pending state.
     should "have a pending state"do
       assert_eqaul 'pending', @user_friendship.state
     end
   end

   context"#send_request_email"do
     setup do
     	@user_friendship = UserFriendship.create user: users(:prabhakar),friend:users(:zuke)
     end

     should"send an email"do
      assert_difference 'ActionMialer :: Base.deliveries.size',1 do
      	@user_friendship.send_request_email
      end
    end
  end

  context"#mutual_friendship"do
    setup do
      UserFriendship.request users(:prabhakar), users(:zuke)
      @friendship1 = users(:prabhakar).user_friendship.where(friend_id:users(:zuke).id).first
      @friendship2 = users(:prabhakar).user_friendship.where(friend_id:users(:zuke).id).first
    end
     should" correctly find  mutual friendship"do
        assert_equal @friendship2, @friendship1.mutual_friendship     
end



 # When  the user 1 sent  friend request to the user 2
 # It allocates the mutual friend relation between the two users
 # if the user1 accepts the friend request of the user2.

context"#accept_mutual friendship"do
  setup do
    UserFriendship.request users(:prabhakar),users(:zuke)
  end
  should "accept the mutual friendship"do
    friendship1 =  users(:prabhakar).user_friendship.where(:friend_id: users(:zuke))

    # Once the user 1 accepts the friend request of user 2
    # the user1 pending friend requests list would be updated as Friends.
    # as well as the user 2 frined request would be updated as accepted.

  context "#accept!"do
   setup do
    @user_friendship = UserFriendship.request users(:prabhakar),friend:users(:zuke)
   # @user_friendship = UserFriendship.create user: users(:zuke),friend:users(:prabbhakar).id).first

friendship1.accept_mutual_friendship!
friendship2.reload
assert_equal 'accepted', friendship2.state
  end
 end
end

 should "set the state to accepted"do
  @user_friendship.accept!
    assert_equal "accepted", @user_friendship.state
   end
  
#If the user accepts his/her friend request
# It would send an email saying that your friend
# request has been accepted.
   should "send an acceptence email"do
    assert_difference "ActionMailer::Base.deliveries.size",1 do
      @user_friendship.accept!
    end
  end

   # Once the friend request is accepted , 
   # then that friend would be also added to the  friends list of the user.
   should "include the friend in the list of friends"
    @user_friendship.accept!
    users(:prabhakar).friends.reload
     assert users(:prabhakar).friends.include?(:zuke))
   end
  end 

  should "accept the mutual friendship"do
  @user_friendship.accept!
     assert_equal 'accepted', @user_friendship.mutual_friendship.state
   end
 end



  context ".request"do
    should "create two user friendships"do
     assert_difference 'UserFriendship.count',2 do
      UserFriendship.request(users(:prabhakar),users(:zuke))
     end
    end


    # It should send an email to the user as a friend request.
    should "send a friend request email"do
      assert_difference 'ActionMailer::Base.deliveries.size',1 do
        UserFriendship.request(users(:prabhakar), users(:zuke))
      end
  end 
end

context"#delete_mutual_friendship!"do
  setup do
  UserFriendship.request users(:prabhakar).users(:zuke)
    @friendship1 = users(:prabhakar).user_friendship.where(friend_id: users(:zuke).id).first
    @friendship2 = users(:zuke).user_friendship.where(:friend_id: users(:prabhakar).id).first
  end
  should "delete the mutual friendship"do
    assert_equal @friendship2, @friendship1.mutual_friendship
    @friendship1.delete_mutual_friendship!
    assert !UserFriendship.exists?(@friendship2.id)
end
end

context "on destroy"do
  setup do
    UserFriendship.request users(:prabhakar).users(:zuke)
    @friendship1 = users(:prabhakar).user_friendship.where(friend_id: users(:zuke).id).first
    @friendship2 = users(:zuke).user_friendship.where(:friend_id: users(:prabhakar).id).first
end

 should"delete the mutual friendship"do
   @friendship1.destroy
   assert !UserFriendship.exists?(@friendship2.id)

  end
 end

 context"#block!"do
   setup do
    @user_friendship = UserFriendship.request users(:prabhakar), users(:zuke)
   end

   should "set the state to blocked"do
    @user_friendship.block!
    assert_equal 'blocked', @user_friendship.state
    assert_equal 'blocked', @user_friendship.mutual_friendship.state
    end


    should "not allow new requests once blocked"do
     @user_friendship.block!
     uf = UserFriendship.request users(:prabhakar), users(:zuke)
     assert !uf.save
     end
    end
  end





