class ProductsThreeLevelCategory < ActiveRecord::Base
	establish_connection "admin".to_sym
  attr_accessible :product_id ,:third_level_id
  
  def self.delete_table_rows
    delete_all
  end
end
