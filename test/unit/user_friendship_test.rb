require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)

	test "that creating a friendship works without raising an exception ."do 
	assert_nothing_raised do
	UserFriendship.create user: users(:Prabhakar), friend: users(:Zuke)
     end	
	end

	test "that creating a friendship  based on user id and friend id  works ."do 
	UserFriendship.create user: users(:Prabhakar), friend: users(:Zuke)
	assert users(:Prabhakar).friends.include?(users(:Zuke))
   end
  end	
