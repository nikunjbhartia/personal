class ValidationController < ActionController::Base
  include Validation

  def new 
    
  end

  def validate_categories
    @result = Validation::ValidateCategories.validate(params[:xls_file])
    p "========= Result ======"
    p @result
  end




end
