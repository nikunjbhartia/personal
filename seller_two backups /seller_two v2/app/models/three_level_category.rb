class ThreeLevelCategory < ActiveRecord::Base
   establish_connection "admin".to_sym
	enum level: [ '0' , '1' , '2'  ]
    attr_accessible :name , :parent_id , :level

  

   def children_names
   	 if ["0","1"].include?(self.level)
   	 ThreeLevelCategory.where(level: self.level.to_i + 1,parent_id: self.id).map &:name
   	else
   		"Not level 0 or 1"
   	end
   end

   def self.delete_table_rows
   	  delete_all
   end
end
