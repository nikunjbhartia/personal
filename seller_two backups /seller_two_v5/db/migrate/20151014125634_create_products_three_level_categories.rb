class CreateProductsThreeLevelCategories < ActiveRecord::Migration
  def change
    create_table :products_three_level_categories do |t|
      t.integer :product_id
      t.integer :third_level_id

      t.timestamps null: false
    end
  end
end
