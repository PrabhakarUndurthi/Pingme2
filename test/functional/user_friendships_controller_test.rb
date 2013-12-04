require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
      end
    end


    # When the user logged in, he could see many things in his/her account.
    # Few things which would appear to him is 
    # Pending Friendships
    # Accepted friends
    # Requested friendships
    # Blocked friendships.

    context "when logged in" do
      setup do
        @pending_friendship   = create(:pending_user_friendship, user: users(:prabhakar), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @accepted_friendship  = create(:accepted_user_friendship, user: users(:prabhakar), friend: create(:user, first_name: 'Active', last_name: 'Friend'))
        @requested_friendship = create(:requested_user_friendship, user: users(:prabhakar), friend: create(:user, first_name: 'Requested', last_name: 'Friend'))
        @blocked_friendship   = user_friendships(:blocked_by_prabhakar)

        sign_in users(:prabhakar)
        get :index
      end

      should "get the index page without error" do
        assert_response :success
      end

      should "assign user_friendships" do
        assert assigns(:user_friendships)
      end

      should "display friend's names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      # when the user clicks on the pending friendship button
      # It would display the details of the user
      # with a message saying like "This frienship is still been pending."

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@pending_friendship.id}" do
          assert_select "em", "Friendship is pending"
        end
      end

      # Upon successfull acceptence of the friendships
      # It will the date of  that friendship.

      should "display date information on an accepted friendship" do
        assert_select "#user_friendship_#{@accepted_friendship.id}" do
          assert_select "em", "Friendship is accepted"
        end
      end


      # Display the pending users list.
      context "blocked users" do
        setup do
          get :index, list: 'blocked'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

      # Display the blocked users list.
        should "display blocked friend names" do
          assert_match /Blocked\ Friend/, response.body
        end
      end


      # Display the pending frienships list.

      context "pending friendships" do
        setup do
          get :index, list: 'pending'
        end

        should "get the index without error" do
          assert_response :success
        end



       # Pending friends list with their fullnames.
        should "display pending friend's names" do
          assert_select "div#friend-list", {count: 1, html: /#{@pending_friendship.friend.full_name}/ }
          assert_select "div#friend-list", {count: 0, html: /#{@blocked_friendship.friend.full_name}/ }
        end

        should "display blocked friends" do
          assert_match /Pending/, response.body
        end
      end


     # Display the details of the requested friendship list.
      context "requested friendships" do
        setup do
          get :index, list: 'requested'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_select "div#friend-list", {count: 1, html: /#{@requested_friendship.friend.full_name}/ }
          assert_select "div#friend-list", {count: 0, html: /#{@blocked_friendship.friend.full_name}/ }
          assert_select "div#friend-list", {count: 0, html: /#{@pending_friendship.friend.full_name}/ }
          assert_select "div#friend-list", {count: 0, html: /#{@accepted_friendship.friend.full_name}/ }
        end

        should "display requested friends" do
          assert_match /Requested/, response.body
        end
      end

      context "accepted friendships" do
        setup do
          get :index, list: 'accepted'
        end

        should "get the index without error" do
          assert_response :success
        end


      # Display the current friends list , I mean active users in the list.
        should "display active friend's names" do
          assert_select "div#friend-list", {count: 1, html: /#{@accepted_friendship.friend.full_name}/ }
          assert_select "div#friend-list", {count: 0, html: /#{@blocked_friendship.friend.full_name}/ }
        end

        should "display requested friends" do
          assert_match /Active/, response.body
        end
      end


    end
  end  


  # Once the user logged in to the account? It would return to the success login page

  context "#new" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:prabhakar)
      end

      should "get new and return success" do
        get :new
        assert_response :success
      end

      should "should set a flash error if the friend_id params is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end


      # Display the full frineds name

      should "display the friend's name" do
        get :new, friend_id: users(:michel)
        assert_match /#{users(:michel).full_name}/, response.body
      end

      should "assign a new user friendship" do
        get :new, friend_id: users(:michel)
        assert assigns(:user_friendship)
      end


     # it would assign the  new friendship to the currently logged in user.
      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:michel)
        assert_equal users(:michel), assigns(:user_friendship).friend
      end

      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:michel)
        assert_equal users(:prabhakar), assigns(:user_friendship).user
      end

      should "returns a 404 status if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end


     # before the friendship actually begins, it will prompt
     # a message about exatly what does it mean by accepting that friendship.
      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:michel)
        assert_match /Do you really want to friend #{users(:michel).full_name}?/, response.body
      end
    end
  end

  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end


   # when the user logged in successfully
    context "when logged in" do
      setup do
        sign_in users(:prabhakar)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to the site root" do
          assert_redirected_to root_path
        end
      end

      # MAKING NEW FRIENDSHIPS

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: { friend_id: users(:zuke).profile_name }
          end
        end
      end

      context "with a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:zuke).profile_name }
        end

        # ASSING  NEW FRIEND OBJECT TO THE CURRENTLY LOGGED IN USER

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:zuke, assigns(:friend)
        end



       # If the currnely logged in user wants to send a friend request to the others!.
       # it will assing that specific new user id to the  currently logged in user.
        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:prabhakar), assigns(:user_friendship).user
          assert_equal users(:zuke), assigns(:user_friendship).friend
        end

      # Creating the friendship b/w two users.

        should "create a friendship" do
          assert users(:prabhakar).pending_friends.include?(users(:zuke))
        end

        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:zuke))
        end

        # After the friend request has been successfully 
        # sent It will flash a success message.

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent.", flash[:success]
        end
      end
    end
  end


  # ACCEPTING NEW FRIENDSHIPS.

  context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    # once the user logged in, He will see a bunch of new friend requests.
    # If any request got accepted then, It would be put in to accepted state.

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:prabhakar), friend: @friend)
        create(:pending_user_friendship, friend: users(:prabhakar), user: @friend)
        sign_in users(:prabhakar)
      end

      def do_put
        put :accept, id: @user_friendship
        @user_friendship.reload
      end


      # Assigning the friendship to the two users.

      should "assign a user_friendship" do
        do_put
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      # once if any request got accepted, then it would be 
      # put in to accepted state.

      should "update the state to accepted" do
        do_put
        assert_equal 'accepted', @user_friendship.state
      end

      # Upon the new creation of the friendship, the user will be  intimated 
      #  that  he is now friends with the new user "NAME"

      should "have a flash success message" do
        do_put
        assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:success]
      end

      # COUNTS THE NO OF FRIENDS.

      should "create activity" do
        assert_difference "Activity.count" do
          do_put
        end
      end
    end
  end

  context "#edit" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :edit, id: 1
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:prabhakar))
        sign_in users(:prabhakar)
        get :edit, id: @user_friendship.friend.profile_name
      end

      should "get edit and return success" do
        assert_response :success
      end

      should "assign to user_friendship" do
        assert assigns(:user_friendship)
      end

      should "assign to friend" do
        assert assigns(:friend)
      end
    end
  end


  # DELETING THE FRIENDSHIPS.

  context "#destroy" do
    context "when not logged in" do
      should "redirect to the login page" do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end


    # Once the user successfully logged in he could delete OR cancel friendships.

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:prabhakar))
        create(:accepted_user_friendship, friend: users(:prabhakar), user: @friend)

        sign_in users(:prabhakar)
      end


     # if the user chooses an account to be deleted from his frieds list.
     # he could do that.
      should "delete user friendships" do
        assert_difference 'UserFriendship.count', -2 do
          delete :destroy, id: @user_friendship
        end
      end


     # Upon the successful  deletion of the frinedship
     # he will be notified.
      should "set the flash" do
        delete :destroy, id: @user_friendship
        assert_equal "Friendship destroyed", flash[:success]
      end
    end
  end


  # BLOCKING THE FRIENDSHIPS.

  context "#block" do
    context "when not logged in" do
      should 'redirect to the login page' do
        put :block, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:prabhakar))
        sign_in users(:prabhakar)
        put :block, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the user friendship state to blocked" do
        assert_equal 'blocked', @user_friendship.state
      end
    end
  end


end
