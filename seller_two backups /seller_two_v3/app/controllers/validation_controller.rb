class ValidationController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include Validation

  def new
  end

  def validate_categories
    begin
      @result = Validation::ValidateCategories.validate(params[:xls_file])
      p "========= Result Validate======"
      p @result
      p params
      redirect_to :controller => 'migration' , :action => 'new' , :filename => params[:xls_file] if !@result.nil?
    rescue Exception => e
      render "error"
    end
  end

  def error
  end




end
