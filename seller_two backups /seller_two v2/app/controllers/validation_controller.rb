class ValidationController < ActionController::Base
  include Validation

  def new 
    
  end

  def validate_categories
    @result = Validation::ValidateCategories.validate(params[:xls_file])
    p "========= Result Validate======"
    p @result
    p params
    
    redirect_to :controller => 'migration' , :action => 'new' , :filename => params[:xls_file] if !@result.nil?
  end




end
