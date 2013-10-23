	require 'test_helper'

	class UserTest < ActiveSupport::TestCase
		should have_many(:user_friendships)
		should have_many(:friends)

	#Allowing the user to enter the first_name
	#If the fails to enter the characters,it throws an error
		test  "a.user should enter a.first name" do 
			user = User.new
			assert !user.save
			assert !user.errors[:first_name].empty?
		end	

	#Allowing the user to enter the last_name
	#If the fails to enter the characters,it throws an error
	  test  "a.user should enter a.last name" do 
			user = User.new
			assert !user.save
			assert !user.errors[:last_name].empty?
		end	

	#Allowing the user to enter the profile_name
	#If the fails to enter the characters,it throws an error
		test  "a.user should enter a.profile name" do 
			user = User.new
			assert !user.save
			assert !user.errors[:profile_name].empty?
		end	
		#Allowng the user to have  a unique profile name
		#If the user enter ,allreadt existing name , it throws an error.
		test  "a.user should enter a.unique profile name" do 
			user = User.new
			user.profile_name = "Prabhakar Undurthi"
			user.email =   "undurthi_prabhakar@aol.com"
			user.first_name = "Prabhakar"
			user.last_name = "Undurthi"
			user.password ="password"
			user.password_confirmation = "password"
			assert !user.save
			assert !user.errors[:profile_name] .empty?
		 end


	       #Allowing the user to enter the profile name without any spaces.
	       #If the user enter the profile name with spaces ,it throws an error.
		   test "a user should have a profile name without spaces" do
		   	user = User.new
		   	user =User.new(first_name: 'Michel', last_name: 'Joe',email: "micheljoe85@gmail.com")
	        user.password = user.password_confirmation = 'hfkdkja'
		   	user.profile_name = "My profile with spaces"
		   	assert !user.save
		   	assert !user.errors[:profile_name].empty?
		   	assert user.errors[:profile_name].include?("Must be formatted correctly.")
		   end

	test "a user can have a correctly formatted profile name"do
	user =User.new(first_name: 'Michel', last_name: 'Joe',email: "micheljoe85@gmail.com")
	user.password = user.password_confirmation = 'hfkdkja'
	user.profile_name = "MichelJoe"
	assert.user.valid
 end

 test "that no error is raised when trying to access a friend list"do
 assert_nothing_raisedd do
 	users(:Prabhakar).friends
   end
  end
  test "That creating friendships on a user works"do
  users(:Prabhakar).friends << users(:Zuke)
  assert.users(:Prabhakar).friends.include?(users(:Zuke))
  end
end

