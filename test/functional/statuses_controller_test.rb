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
      sign_in users(:Prabhakar) 
       get :new
       assert_response :success
  end

#Before the user post anything new status ,it checks the user to sign in to that activity.
test "should be logged in to post a status" do
  post :create, status: {content: "Hello"}
  assert_redirected_to new_user_session_path

end


  test "should create status when logged in  " do
    sign_in users(:Prabhakar) 
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end


#Display the user status with the Id
  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

# Allowing the user to edit the status when logged in.
  test "should get edit when logged in " do
    sign_in users(:Prabhakar) 
    get :edit, id: @status
    assert_response :success
  end

  test "should  redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_responce :redirect
    assert_redirected_to status_path(assigns(:status))
  end

#If the user wants to delete the status.
  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
