json.array!(@user_profiles) do |user_profile|
  json.extract! user_profile, :id, :signup_reason, :date_of_birth, :gender, :student_type, :education_status, :current_degree, :user_id_id
  json.url user_profile_url(user_profile, format: :json)
end
