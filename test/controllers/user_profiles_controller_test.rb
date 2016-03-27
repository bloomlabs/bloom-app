require 'test_helper'

class UserProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user_profile = user_profiles(:david_profile)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_profile" do
    assert_difference('UserProfile.count') do
      post :create, user_profile: {
          user: @user_profile.user,
          signup_reason: @user_profile.signup_reason,
          date_of_birth: @user_profile.date_of_birth,
          gender: @user_profile.gender,
          education_status: @user_profile.education_status,
          university_degree: @user_profile.university_degree,
          nationality: @user_profile.nationality,
      }
    end

    assert_response :redirect
  end

end
