require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test  "a.user should enter a.first name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end	
  


  test  "a.user should enter a.last name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end	



	test  "a.user should enter a.profile name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end	


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
user.profile_name = "Joe"
assert.user.valid?

  end
end
