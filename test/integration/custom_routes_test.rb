require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  # redirecting the user to the success hompage ,after succesfull login activity
  #user should enter the valid details.
	test "that /login route opens the login page"  do
   get '/login'
   assert_response :success
   end
  
   #redirecting the user to the route ,after succesful logout activity.
   test "that /logout route opens the logout page"  do
   get '/logout'
   assert_response :redirect
   assert_redirected_to '/'
   
  end
    #redirecting the user to the signup page for the new registration.
  	test "that /register route opens the sign up page"  do
   get '/register'
   assert_response :success
   end

   test "that a profile page works"do
   get '/Prabhakar'
   assert_response :success
 end
 

end
