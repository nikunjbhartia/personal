class MigrationController < ActionController::Base
  include Validation
  def new 
    @filename = params[:filename]
    p params
  end

  def migrate_categories
  	p "========== params ======="
  	p params
    p @filename

    @result = Migration::MigrateCategories.start_migration(params[:file][:name])

    p "========= Result ======"
    p @result
  end

  def delete
     Migration::DeleteMigrationTableRows.delete_rows
  end





end
