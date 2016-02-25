class MigrationController < ApplicationController
  include Validation
  def new 
    @filename = params[:filename]
    p params
  end

  def migrate_categories
  	p "========== params ======="
  	p params
    p @filename
    @status = "migrating"
    @result = Migration::MigrateCategories.start_migration(params[:filename])

    p "========= Result ======"
    p @result
   
    # render 'new'
  end

  def delete
     Migration::DeleteMigrationTableRows.delete_rows
     @status="deleting"
     render 'new',:filename => params[:filename]
  end





end
