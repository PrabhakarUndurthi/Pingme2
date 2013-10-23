      require 'test_helper'

      class ProfilesControllerTest < ActionController::TestCase
          test "should get show" do
          get :show, id:users(:Prabhakar).profile_name
          assert_response :success
          assert_template 'profiles/show'
        end

        #If the user profle name is not found , then it throws an error message 
        #which contains the 404 code.
        test "Should render a 404 on profile not found"do
        get :show, id: "doesn't exist"
        assert_response :not_found
        end

        test "that variables are assigned on successful profile viewing"do
        get :show, id: users(:Prabhakar).profile_name
        assert assigns(:user)
        assert_not-empty assigns(:statuses)

      end

      # when the user enters the correct profile name , it displays 
      #the user name and the statuse of the user.
      test "only shows the correct user's statuses"do
      get :show, id: users(:Prabhakar).profile_name
      assigns(:statuses).each do |status|
        assert_equal users(:Prabhakar), status.user
      end
    end



