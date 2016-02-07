json.array!(@memberships) do |membership|
  json.extract! membership, :id, :name, :price, :recurring, :dates
  json.url membership_url(membership, format: :json)
end
