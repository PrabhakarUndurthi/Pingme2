
require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

  context "#new"do
    context "when not logged in "do
      should "redirect to the login page"do
      get :new
   assert_response :redirect
    end
   end

   context "when logged in "do
   setup do
   	sign_in users(:prabhakar)
   end


   should "get new and return success"do
     get :new
     assert_response :success
    end

    should "should set a flash error if the friend_id params is missing."do
      get :new,{}
      assert_equal "Friend required", flash[:error]
    end

    should "display the friend's name"do
      get :new, friend_id: users(:michel)
      assert_match /#{users(:michel).full_name}/,response.body
     end

     should "assigns a new user friendship"do
       get :new, friend_id: users(:michel)
      assert assigns(:user_friendship)
     end


    should "assigns a new user friendship to the correct friend"do
     get :new, friend_id: users(:michel)
     assert_equal users(:michel),assigns(:user_friendship).friend
     end

    should "assigns a new user friendship to the corrently logged in user"do
      get :new, friend_id: users(:michel)
      assert_equal users(:prabhakar),assigns(:user_friendship).user
     end

     should "returns a 404 status if no friend is found"do
       get :new, friend_id: 'invalid'
       assert_response :not_found
     end

     should "ask if you really want to friend the user" do
        get :new, friend_id: users(:michel)
        assert_match /Do you really want to friend #{users(:michel).full_name}?/, response.body
      end
    end
  end

  context "#create"do
    context "when not logged in"do
     should "redirect to the login page"do
       get :new
       assert_response :redirect
       assert_redirected_to login_path
     end
   end


   context "when logged in"do
    setup do
       sign_in users(:prabhakar)
     end

  context "with no friend_id"do
    setup do
      post :create
    end

  should"set the flash error message"do
    assert !flash[:error]  .empty?
  end

  should"redirect to the site root"do
    assert_redirected_to root_path
  end
end


 context "with a valid friend_id"do
   setup do
    post :create, user_friendship: { friend_id: users(:zuke)}
  end


  should "assigns a friend object"do
    assert assigns(:friend)
      assert_equal users(:zuke), assigns(:friend)
    end


    should"assign a user_friendship object"do
       assert assigns(:user_friendship)
       assert_equal users(:prabhakar), assigns(:user_friendship).user
       assert_equal users(:zuke), assigns(:user_friendship).friend
       end


       should "create a friendship"do
         assert users(:prabhakar).friends.include?(users(:zuke))
     end

     should"redirect to the profile page of the friend"do
       assert_response :redirect
       assert_redirected_to profile_path(users(:zuke))
     end

     should"set the flash succes message"do
       assert flash[:success]
        assert_equal"You are now friends with #{users(:zuke).full_name}",flash[:success]
      end
    end
   end
 end




