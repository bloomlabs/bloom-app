require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @normal_user = users(:david)
    @staff_user = users(:john)
    @super_user = users(:bill)
  end

  test "get index not logged in" do
    get :index
    assert_response :success
  end

  test "get dashboard not logged in" do
    get :dashboard
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  test "get index normal user" do
    sign_in @normal_user
    get :index
    assert_redirected_to controller: 'welcome', action: 'dashboard'
  end

  test "get dashboard normal user" do
    sign_in @normal_user
    get :dashboard
    assert_response :success
  end

  test "get index staff user" do
    sign_in @staff_user
    get :index
    assert_redirected_to controller: 'welcome', action: 'dashboard'
  end

  test "get index super user" do
    sign_in @super_user
    get :index
    assert_redirected_to controller: 'welcome', action: 'dashboard'
  end
end
