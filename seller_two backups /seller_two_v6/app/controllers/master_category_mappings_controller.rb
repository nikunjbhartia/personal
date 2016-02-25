class MasterCategoryMappingsController < ApplicationController
  before_action :set_master_category_mapping, only: [:show, :edit, :update, :destroy]
  layout 'manage'
  # GET /master_category_mappings
  # GET /master_category_mappings.json
  def index
    @master_category_mappings = MasterCategoryMapping.all
  end

  # GET /master_category_mappings/1
  # GET /master_category_mappings/1.json
  def show
  end

  # GET /master_category_mappings/new
  def new
    @master_category_mapping = MasterCategoryMapping.new
  end

  # GET /master_category_mappings/1/edit
  def edit
  end

  # POST /master_category_mappings
  # POST /master_category_mappings.json
  def create
    @master_category_mapping = MasterCategoryMapping.new(master_category_mapping_params)

    respond_to do |format|
      if @master_category_mapping.save
        format.html { redirect_to @master_category_mapping, notice: 'Master category mapping was successfully created.' }
        format.json { render :show, status: :created, location: @master_category_mapping }
      else
        format.html { render :new }
        format.json { render json: @master_category_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_category_mappings/1
  # PATCH/PUT /master_category_mappings/1.json
  def update
    respond_to do |format|
      if @master_category_mapping.update(master_category_mapping_params)
        format.html { redirect_to @master_category_mapping, notice: 'Master category mapping was successfully updated.' }
        format.json { render :show, status: :ok, location: @master_category_mapping }
      else
        format.html { render :edit }
        format.json { render json: @master_category_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_category_mappings/1
  # DELETE /master_category_mappings/1.json
  def destroy
    @master_category_mapping.destroy
    respond_to do |format|
      format.html { redirect_to master_category_mappings_url, notice: 'Master category mapping was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_category_mapping
      @master_category_mapping = MasterCategoryMapping.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_category_mapping_params
      params[:master_category_mapping]
    end
end
