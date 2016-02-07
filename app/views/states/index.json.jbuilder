json.array!(@states) do |state|
  json.extract! state, :id, :name, :about
  json.url state_url(state, format: :json)
end
