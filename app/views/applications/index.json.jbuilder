json.array!(@applications) do |application|
  json.extract! application, :id, :user_id, :membership_id, :state_id
  json.url application_url(application, format: :json)
end
