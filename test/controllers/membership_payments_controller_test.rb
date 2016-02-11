require 'test_helper'

class MembershipPaymentsControllerTest < ActionController::TestCase
  test "should get pay_single" do
    get :pay_single
    assert_response :success
  end

  test "should get start_subscription" do
    get :start_subscription
    assert_response :success
  end

  test "should get cancel_subscription" do
    get :cancel_subscription
    assert_response :success
  end

end
