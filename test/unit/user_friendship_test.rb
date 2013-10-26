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
	assert users(:prabhakar).friends.include?(users(:zuke))
   end

   context "a new instance"do
     setup do
     	@user_friendship = UserFriendship.new user: users(:prabhakar),friend: users(:zuke)
     end


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

  context "#accept!"do
   setup do
    @user_friendship = UserFriendship.create user: users(:prabhakar),friend:users(:zuke)

end

 should "set the state to accepted"do
  @user_friendship.accept!
   assert_equal "accepted", @user_friendship.state
   end


   should "send an acceptence email"do
    assert_difference "ActionMailer::Base.deliveries.size",1 do
      @user_friendship.accept!
    end
  end
  end 
end

