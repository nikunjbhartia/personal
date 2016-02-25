class CreateRevisedTwoLevelCategories < ActiveRecord::Migration
  def change
    create_table :revised_two_level_categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :level

      t.timestamps null: false
    end
  end
end
