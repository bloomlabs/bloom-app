require 'test_helper'

class MembershipRequestsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @membership_request = membership_requests(:david_request_new)
  end

  MembershipRequest.workflow_spec.states.keys.each do |current_state|
    MembershipRequest.workflow_spec.states.keys.each do |page_state|
      test "#{current_state} state accessing #{page_state} state page causes #{if current_state != page_state then 'redirect' else 'success' end}" do
        @membership_request = membership_requests("david_request_#{current_state}")
        sign_in @membership_request.user

        get "workflow_#{page_state}", id: @membership_request.id

        if current_state == page_state
          assert_response :success
        else
          assert_redirected_to controller: 'membership_requests', action: "workflow_#{current_state}"
        end
      end
    end

    test "should redirect to #{current_state} state page" do
      @membership_request = membership_requests("david_request_#{current_state}")
      sign_in @membership_request.user
      get :show, id: @membership_request.id
      assert_redirected_to controller: 'membership_requests', action: "workflow_#{current_state}"
    end

    test "accessing #{current_state} state page while not logged in causes login prompt" do
      get "workflow_#{current_state}", id: @membership_request.id
      assert_redirected_to controller: 'devise/sessions', action: 'new'
    end

    test "accessing #{current_state} state page while wrong user causes access denied" do
      sign_in users(:sam)
      get "workflow_#{current_state}", id: @membership_request.id
      assert_not_empty flash[:error]
      assert_redirected_to controller: 'welcome', action: 'index'
    end

    test "accessing #{current_state} state page while staff user causes access denied" do
      sign_in users(:john)
      get "workflow_#{current_state}", id: @membership_request.id
      assert_not_empty flash[:error]
      assert_redirected_to '/admin/'
    end

    test "accessing #{current_state} state page while super user causes access denied" do
      sign_in users(:bill)
      get "workflow_#{current_state}", id: @membership_request.id
      assert_not_empty flash[:error]
      assert_redirected_to '/admin/'
    end
  end

  test "should get new" do
    sign_in @membership_request.user
    get :new
    assert_response :success
  end

  #
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:membership_requests)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create membership_request" do
  #   assert_difference('MembershipRequest.count') do
  #     post :create, membership_request: { membership_id: @membership_request.membership_id, startdate: @membership_request.startdate, user_id: @membership_request.user_id }
  #   end
  #
  #   assert_redirected_to membership_request_path(assigns(:membership_request))
  # end
  #
  # test "should show membership_request" do
  #   get :show, id: @membership_request
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @membership_request
  #   assert_response :success
  # end
  #
  # test "should update membership_request" do
  #   patch :update, id: @membership_request, membership_request: { membership_id: @membership_request.membership_id, startdate: @membership_request.startdate, user_id: @membership_request.user_id }
  #   assert_redirected_to membership_request_path(assigns(:membership_request))
  # end
  #
  # test "should destroy membership_request" do
  #   assert_difference('MembershipRequest.count', -1) do
  #     delete :destroy, id: @membership_request
  #   end
  #
  #   assert_redirected_to membership_requests_path
  # end
end
