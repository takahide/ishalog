json.array!(@posts) do |post|
  json.extract! post, :id, :title, :body, :clinics
  json.url post_url(post, format: :json)
end
