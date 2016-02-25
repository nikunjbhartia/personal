module Migration
  class DeleteMigrationTableRows
    
    def self.delete_rows
      ProductsThreeLevelCategory.delete_table_rows
      MasterCategoryMapping.delete_table_rows
      RevisedTwoLevelCategory.delete_table_rows
      ThreeLevelCategory.delete_table_rows
    end
    
  end
end
