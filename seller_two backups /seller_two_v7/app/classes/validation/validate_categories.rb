require 'spreadsheet'
module Validation
  class ValidateCategories

    def self.validate(filename)
      msg = []
      File.open("log/validation.err", 'w') { |file|
        book = Spreadsheet.open filename ; nil
        ss =  book.worksheet 'Base'
        size = ss.to_a.size
        head = ["three_level_l0", "three_level_l1", "three_level_l2", "revised_two_level_l0", "revised_two_level_l1", "current_l0", "current_l1"]
        flag = 1
        
        (1..size-1).each do |i|
          begin
            print ".#{i}"
            row = ss.row(i)
            row = Hash[[head,ss.row(i)].transpose]
            parent_category = Category.where(name: row["current_l0"]).first
            sub_category = Category.where(name: row["current_l1"],parent_id: parent_category.id).first
            sub_category_id = sub_category.id
          rescue Exception => e
            msg << [i+1,row["current_l0"],row["current_l1"]]
            file << "\n=============\n"
            file << "Row #{i+1} | #{e.backtrace[0]} | #{$!} \n"
            file << "Parent,Sub Category combination not present in db : #{row["current_l0"]} -> #{row["current_l1"]}\n"
            file << "==============\n"
            flag=0
          end
        end

        if flag == 1
          p "Validation Successful => All catgeroies present in DB"
          file << "Validation Successful => All catgeroies present in DB"
        else
          p "Validation Unsuccessful => Following category combination not in DB  : #{msg}"
        end
      }
      msg
    end
  end
end
