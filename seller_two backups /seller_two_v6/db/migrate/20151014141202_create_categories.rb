class CreateCategories < ActiveRecord::Migration
  def change
    create_table "categories", force: :cascade do |t|
      t.string  "cat_picture",   limit: 255
      t.string  "name",          limit: 255
      t.integer "order_no",      limit: 4,   default: 0
      t.integer "parent_id",     limit: 4
      t.string  "status",        limit: 255, default: "active"
      t.string  "category_type", limit: 15,  default: "CATEGORY"
      t.string  "old_name",      limit: 255
    end
  end
end
end
