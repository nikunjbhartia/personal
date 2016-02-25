class ValidationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include Validation

  def new
  end

  def validate_categories
      begin
       p "========= Result Validate======"
      p @result
      p "========== Params =============="
      p params
      p "=========== @result.nil? ========"
      p @result.nil?
     
      file_path = params[:filename]#.tempfile.path

      p "=========== filepath ======="
      p file_path
    
      ss = open_spreadsheet(file_path)
     
      p "============== ss =========="
      p ss
     
      @result = Validation::ValidateCategories.validate(ss)
      redirect_to :controller => 'migration' , :action => 'new' , :filename => params[:filename] if @result.blank?
      
      rescue Exception => e
        render "error"
      end
  end

  def open_spreadsheet(original_filename)
    case File.extname(original_filename)
    # encoding UTF-8
    when ".csv" then Roo::CSV.new(original_filename,csv_options: {encoding: "iso-8859-1:UTF-8"})
    when ".xls" then Roo::Excel.new(original_filename)
    when ".xlsx" then Roo::Excelx.new(original_filename)
    else raise Exception
    end
  end

  def error
  end
end
