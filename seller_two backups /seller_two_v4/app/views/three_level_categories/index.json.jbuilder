json.array!(@three_level_categories) do |three_level_category|
  json.extract! three_level_category, :id
  json.url three_level_category_url(three_level_category, format: :json)
end
