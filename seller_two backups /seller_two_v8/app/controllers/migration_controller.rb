class MigrationController < ApplicationController
  include Validation
  def new 
    # for testing below isnt used
    @filename = params[:filename]
    p params
  end

  def migrate_categories
  	p "========== params ======="
  	p params
  
    p "======== @filename ======="
    p @filename

  
    @status = "migrating"
    # @result = Migration::MigrateCategories.start_migration(params[:filename])

     file_path = params[:filename]
     ss = open_spreadsheet(file_path)
      # @result =  Migration::MigrateCategories.start_migration(ss)
   
     @result = MigrationWorker.perform_async(file_path)
    p "========= Result ======"
    p @result
    
    render 'new',:filename => params[:filename]
  end

  def delete
     Migration::DeleteMigrationTableRows.delete_rows
     @status="deleting"
     render 'new',:filename => params[:filename]
  end

  def open_spreadsheet(original_filename)
    case File.extname(original_filename)
    # encoding UTF-8
    when ".csv" then Roo::CSV.new(original_filename,csv_options: {encoding: "iso-8859-1:UTF-8"})
    when ".xls" then Roo::Excel.new(original_filename)
    when ".xlsx" then Roo::Excelx.new(original_filename)
   
    end
  end

  def success
  end


 
end
