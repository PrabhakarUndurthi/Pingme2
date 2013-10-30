require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

# Redirecting the user to the Index page, or Main page .
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "shoud be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end


# Taking  the user to the new page, after  succesfull login details entered  by  the user.
  test "should render the new page when logged in" do
    sign_in users(:prabhakar) 
    get :new
    assert_response :success
  end

# Before the user post anything new status ,it checks whether the user is logged in or not!
test "should be logged in to post a status" do
  post :create, status: {content: "Hello"}
  assert_redirected_to new_user_session_path

end


  test "should create status when logged in"do
    sign_in users(:prabhakar) 
    assert_difference('Status.count') do
    post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end


 # It allows the current user only to create status
 # i.e The user who logged in with his/her log in details.

  test "should create status  for the current user when logged in"do
    sign_in users(:prabhakar) 
    assert_difference('Status.count') do
    post :create, status: { content: @status.content, user_id: users(:michel).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:prabhakar).id

  end


# Display the user status with the Id
  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

# Allowing the user to edit the status when logged in.
  test "should get edit when logged in " do
    sign_in users(:prabhakar) 
    get :edit, id: @status
    assert_response :success
  end

  test "should  redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to status_path(assigns(:status))
  end

  test "Should update status when logged in "do
    sign_in users(:prabhakar)
    put :update, id:@status,status: {content: @status.content}
    assert_redirected_to status_path(assigns(:status))
end


 # It allows the current user , who logged in with his/her log in details
# are only permitted to change/update the status.

test "Should update status for the current user  when logged in "do
  sign_in users(:prabhakar)
  put :update, id:@status,status: {content: @status.content, user_id: users(:michel).id}
  assert_redirected_to status_path(assigns(:status))
  assert_equal assigns(:status).user_id,users(:prabhakar).id
end


# If the user did not make any changes on the existing stauts
# it does not gives the status updated message.

test "Should  not update status if nothing has changed "do
  sign_in users(:prabhakar)
  put :update, id:@status
  assert_redirected_to status_path(assigns(:status))
  assert_equal assigns(:status).user_id,users(:prabhakar).id
end


# If the user wants to delete the status.
  test "should destroy status" do
    assert_difference('Status.count', -1) do
    delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
