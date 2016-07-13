require 'test_helper'

class InterviewersControllerTest < ActionController::TestCase
  test "should get edit_schedule" do
    get :edit_schedule
    assert_response :success
  end

  test "should get save_schedule" do
    get :save_schedule
    assert_response :success
  end

end
