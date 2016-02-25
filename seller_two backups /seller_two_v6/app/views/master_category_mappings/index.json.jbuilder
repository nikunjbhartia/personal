json.array!(@master_category_mappings) do |master_category_mapping|
  json.extract! master_category_mapping, :id
  json.url master_category_mapping_url(master_category_mapping, format: :json)
end
