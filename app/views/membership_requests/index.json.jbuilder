json.array!(@membership_requests) do |membership_request|
  json.extract! membership_request, :id, :user_id, :membership_id, :startdate
  json.url membership_request_url(membership_request, format: :json)
end
