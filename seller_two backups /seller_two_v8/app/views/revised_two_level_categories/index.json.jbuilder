json.array!(@revised_two_level_categories) do |revised_two_level_category|
  json.extract! revised_two_level_category, :id
  json.url revised_two_level_category_url(revised_two_level_category, format: :json)
end
