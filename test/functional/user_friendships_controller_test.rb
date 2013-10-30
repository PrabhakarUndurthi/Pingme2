
require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  # When the current user is not been logged in !
    # it redirects that user to sign in page.
  context "#index"do
    context "when not logged in "do
      should "redirect to the login page"do
      get :index
   assert_response :redirect
    end
   end

   # Once the user logged in , it allows that user to see pending friendship requests.

   context "when logged in "do
   setup do
     @friendship1 = create(:pending_user_friendship, user:users(:prabhakar), friend: create(:user,first_name: 'Pending', last_name:'Friend'))
      @friendship2 =  create(:accepted_user_friendship,user: users(:prabhakar), friend: create(:user,first_name:'Active', last_name: 'Friend'))
   	  sign_in users(:prabhakar)
      get  :index
   end


   should "get the index page without error"do
     assert_response :success
   end


    should "get the index page without error"do
      assert_response :success
 end


    should "assign user_friendships"do
      assert assigns(:user_friendships)
 end


   should "display friend's name"do
      assert_match /Pending/, response.body
    end

   # Displays the inforamtion about the friend request.
    should "display pending information on a pending friendship"do
    assert_select "#user_friendships_#{@friendship.id}"do
      assert_select "em", "Friendship is pending."
    end
   end

# If the user accepts his/her friend request !
# It shows the information about thier new friendship relation.

   should "display date information on an accepted friendship"do
     assert_select "#user_friendship_#{@friendship2.id}"do
       assert_select "em", "Friendship started #{@friendship2.updated_at}."
     end
   end
  end
end


   should "get new and return success"do
     get :new
     assert_response :success
    end

    should "should set a flash error if the friend_id params is missing."do
      get :new,{}
      assert_equal "Friend required", flash[:error]
    end


  # Upon the new friendship relation , it displays the new friend full_name
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

     # It allow the current logged in user to see the new friendship.

    should "assigns a new user friendship to the currently logged in user"do
      get :new, friend_id: users(:michel)
      assert_equal users(:prabhakar),assigns(:user_friendship).user
     end

     should "returns a 404 status if no friend is found"do
       get :new, friend_id: 'invalid'
       assert_response :not_found
     end


# Before accepting the friend request , it asks to the user
# do you want to be friend with  this 'X' person.
     should "ask if you really want to friend the user" do
        get :new, friend_id: users(:michel)
        assert_match /Do you really want to friend #{users(:michel).full_name}?/, response.body
      end
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

context "successfully"do
  should "create two user friendship objects"do
    assert_difference 'UserFriendship.count',2 do
      post :create, user_friendship: { friend_id: users(:prabhakar).profile_name}
   end
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



 # When the user accepts the friend request it assigns the new object(friend) to his/her profile.
    should"assign a user_friendship object"do
       assert assigns(:user_friendship)
       assert_equal users(:prabhakar), assigns(:user_friendship).user
       assert_equal users(:zuke), assigns(:user_friendship).friend
       end


       should "create a friendship"do
         assert users(:prabhakar).pending_friends.include?(users(:zuke))
     end

# Shows the new friend profile page.

     should"redirect to the profile page of the friend"do
       assert_response :redirect
       assert_redirected_to profile_path(users(:zuke))
     end


# Once the friendship is been created , then it will gives back 
# nice little message by indicating to the user 
# Your friend request has been sent.
     should"set the flash succes message"do
       assert flash[:success]
        assert_equal"Friend request sent", flash[:success]
      end
    end
   end
 end

 context "#accept"do
    context "when not logged in"do
    should "redirect to the login page"do
    put :accept, id:1
    assert_response :redirect
    assert_redirected_to login_path
   end
  end

  context "when logged in"do
    setup do
      @friend = create(:user)
      @user_friendship = create(:pending_user_friendship, user: users(:prabhakar), friend:@friend)
      create(:pending_user_friendship, friend:users(:prabhakar), user:@friend)
      sign_in users(:prabhakar)
      put :accept, id: @user_friendship
      @user_friendship.reload
    end


    should"assign a user_friendship"do
       assert assigns (:user_friendship)
       assert_equal @user_friendship, assigns(:user_friendship)
  end

  # After the user accepts the new friendship 
  #it sets that old pending state into accepted state.

  should"update the state to accepted"do
    assert_equal 'accepted', @user_friendship.state
   end

   should"have a flash success message"do
     assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:success]
   end
  end
 end

 context "#edit"do
   context "when not logged in"do
    should"redirect to the logged in"do
      get :edit ,id:1
      assert_response :redirect
  end
end

 context "when logged in"do
    setup do
      @user_friendship = create(:pending_user_friendship, user:users(:prabhakar))
      sign_in users(:prabhakar)
      get :edit,id:@user_friendship
    end

   should"get edit and return success"do
     assert_response :success
     end

     should"assign to user_friendship"do
       assert assigns(:user_friendship)
     end

     should"assign to friend"do
       assert assigns(:user_friendship)
     end
   end
end

context "#destroy"do
    context "when not logged in"do
    should "redirect to the login page"do
    delete :destroy, id:1
    assert_response :redirect
    assert_redirected_to login_path
   end
  end

  context "when logged in"do
    setup do
     @friend =  create(:user)
     @user_friendship = create(:accepted_user_friendship, friend: @friend, user:users(:prabhakar))
     create(:accepted_user_friendship, friend: users(:prabhakar) , user:@friend)
     sign_in users(:prabhakar)
    end

     should"delete user friendships"do
       assert_difference 'UserFriendship.count', -2 do
         delete :destroy, id: @user_friendship
       end
     end
     
  end
end

     
    end






