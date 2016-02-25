class MasterCategoryMapping < ActiveRecord::Base
	establish_connection "admin".to_sym
  attr_accessible :third_level_id,:revised_second_level_id,:current_second_level_id
  
  def self.mapped_categories
     third_level_name = ThreeLevelCategory.select(:name).where(id: self.third_level_id)
     revised_second_level_name = RevisedSecondLevelCategory.select(:name).where(id: self.revised_second_level_id)
     current_second_level_name = CurrentSecondLevel.select(:name).where(id: self.current_second_level_id)
     [third_level_name,revised_second_level_name,current_second_level_name]
  end

  def self.delete_table_rows
    delete_all
  end
end
