class CreateThreeLevelCategories < ActiveRecord::Migration
  def change
    create_table :three_level_categories do |t|
      t.string :name
      t.integer :parent_id ,  default: 0
      # t.enum :level ,:limit => [:zero , :one , :two]
      t.integer :level
      t.timestamps null: false
    end
  end
end
