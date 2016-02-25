class Category < ActiveRecord::Base
	establish_connection "admin".to_sym
	default_scope { where(status: "ACTIVE")}
	attr_accessible :cat_picture,:name,:order_no,:parent_id,:status,:old_name

end
