require 'spreadsheet'

module Migration
  class MigrateCategories

    def self.start_migration(ss)
      msg = []
      File.open("log/migration.err", 'w') { |file|
        # book = Spreadsheet.open filename ; nil
        # ss =  book.worksheet 'Base'
        size = ss.to_a.size
        head = ["three_level_l0", "three_level_l1", "three_level_l2", "revised_two_level_l0", "revised_two_level_l1", "current_l0", "current_l1"]
        
        (2..size).each do |i|
          begin
            print ".#{i}"
            row = ss.row(i)
            row = Hash[[head,ss.row(i)].transpose]
            current_first_level = Category.where(name: row["current_l0"]).first
            current_second_level = Category.where(name: row["current_l1"],parent_id: current_first_level.id).first
            revised_first_level = RevisedTwoLevelCategory.find_or_create_by(name: row["revised_two_level_l0"],level: 0)
            revised_second_level = RevisedTwoLevelCategory.find_or_create_by(name: row["revised_two_level_l1"],level: 1,parent_id:  revised_first_level.id)
            three_l_first = ThreeLevelCategory.find_or_create_by(name: row["three_level_l0"],level: 0)
            three_l_second = ThreeLevelCategory.find_or_create_by(name: row["three_level_l1"],level: 1,parent_id: three_l_first.id)
            three_l_third = ThreeLevelCategory.find_or_create_by(name: row["three_level_l2"],level: 2,parent_id: three_l_second.id)
            master = MasterCategoryMapping.find_or_create_by(third_level_id: three_l_third.id, revised_second_level_id: revised_second_level.id, current_second_level_id: current_second_level.id)
            master_id = master.id
          rescue Exception => e

            file << "\n=============\n"
            file << "Row #{i} | #{e.backtrace[0]} | #{$!} \n"
            file << "Erroneous category combination : #{row["current_l0"]} -> #{row["current_l1"]}\n"
            file << "==============\n"
            msg << [row["current_l0"],row["current_l1"]]
          end
        end
      }
      msg
    end
  end
end
