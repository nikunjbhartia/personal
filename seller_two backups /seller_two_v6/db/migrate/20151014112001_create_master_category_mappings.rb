class CreateMasterCategoryMappings < ActiveRecord::Migration
  def change
    create_table :master_category_mappings do |t|
      t.integer :third_level_id
      t.integer :revised_second_level_id
      t.integer :current_second_level_id

      t.timestamps null: false
    end
  end
end
