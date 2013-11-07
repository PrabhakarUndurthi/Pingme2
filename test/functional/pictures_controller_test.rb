require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  setup do
    @picture = pictures(:one)
    @album   = albums(:vacation)
    @user    = users(:prabhakar)
    @default_params = { profile_name: @user.profile_name, album_id: @album.id }
  end

  test "should get index" do
    get :index, @default_params
    assert_response :success
    assert_not_nil assigns(:pictures)
  end

  test "should get new" do
    sign_in users(:prabhakar)
    get :new, @default_params
    assert_response :success
  end

  test "should create picture" do
    sign_in users(:prabhakar)
    assert_difference('Picture.count') do
      post :create, @default_params.merge(picture: { caption: @picture.caption, description: @picture.description })
    end

    assert_redirected_to album_pictures_path(@user.profile_name, @album.id)
  end

  test "should create activity on create" do
    sign_in users(:prabhakar)
    assert_difference 'Activity.count', 1 do
      post :create, @default_params.merge(picture: { caption: @picture.caption, description: @picture.description })
    end
  end


  test "should show picture" do
    get :show, @default_params.merge(id: @picture)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:prabhakar)
    get :edit, @default_params.merge(id: @picture)
    assert_response :success
  end

  test "should update picture" do
    sign_in users(:prabhakar)
    put :update, @default_params.merge(id: @picture, picture: { caption: @picture.caption, description: @picture.description })
    assert_redirected_to album_pictures_path(@user.profile_name, @album.id)
  end

  test "should create activity on update" do
    sign_in users(:prabhakar)
    assert_difference 'Activity.count', 1 do
      put :update, @default_params.merge(id: @picture, picture: { caption: @picture.caption, description: @picture.description })
    end
  end

  test "should destroy picture" do
    sign_in users(:prabhakar)
    assert_difference('Picture.count', -1) do
      delete :destroy, @default_params.merge(id: @picture)
    end

    assert_redirected_to album_pictures_path
  end

  test "should create activity on destroy" do
    sign_in users(:prabhakar)
    assert_difference('Activity.count', 1) do
      delete :destroy, @default_params.merge(id: @picture)
    end
  end
end
