require 'test_helper'

class MembershipRequestsControllerTest < ActionController::TestCase
  setup do
    @membership_request = membership_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:membership_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create membership_request" do
    assert_difference('MembershipRequest.count') do
      post :create, membership_request: { membership_id: @membership_request.membership_id, startdate: @membership_request.startdate, user_id: @membership_request.user_id }
    end

    assert_redirected_to membership_request_path(assigns(:membership_request))
  end

  test "should show membership_request" do
    get :show, id: @membership_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @membership_request
    assert_response :success
  end

  test "should update membership_request" do
    patch :update, id: @membership_request, membership_request: { membership_id: @membership_request.membership_id, startdate: @membership_request.startdate, user_id: @membership_request.user_id }
    assert_redirected_to membership_request_path(assigns(:membership_request))
  end

  test "should destroy membership_request" do
    assert_difference('MembershipRequest.count', -1) do
      delete :destroy, id: @membership_request
    end

    assert_redirected_to membership_requests_path
  end
end
