json.array!(@products_three_level_categories) do |products_three_level_category|
  json.extract! products_three_level_category, :id
  json.url products_three_level_category_url(products_three_level_category, format: :json)
end
