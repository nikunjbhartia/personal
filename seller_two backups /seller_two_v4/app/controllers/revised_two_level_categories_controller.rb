class RevisedTwoLevelCategoriesController < ApplicationController
  before_action :set_revised_two_level_category, only: [:show, :edit, :update, :destroy]
  
  layout 'manage'
  
  # GET /revised_two_level_categories
  # GET /revised_two_level_categories.json
  def index
    @revised_two_level_categories = RevisedTwoLevelCategory.all
  end

  # GET /revised_two_level_categories/1
  # GET /revised_two_level_categories/1.json
  def show
  end

  # GET /revised_two_level_categories/new
  def new
    @revised_two_level_category = RevisedTwoLevelCategory.new
  end

  # GET /revised_two_level_categories/1/edit
  def edit
  end

  # POST /revised_two_level_categories
  # POST /revised_two_level_categories.json
  def create
    @revised_two_level_category = RevisedTwoLevelCategory.new(revised_two_level_category_params)

    respond_to do |format|
      if @revised_two_level_category.save
        format.html { redirect_to @revised_two_level_category, notice: 'Revised two level category was successfully created.' }
        format.json { render :show, status: :created, location: @revised_two_level_category }
      else
        format.html { render :new }
        format.json { render json: @revised_two_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /revised_two_level_categories/1
  # PATCH/PUT /revised_two_level_categories/1.json
  def update
    respond_to do |format|
      if @revised_two_level_category.update(revised_two_level_category_params)
        format.html { redirect_to @revised_two_level_category, notice: 'Revised two level category was successfully updated.' }
        format.json { render :show, status: :ok, location: @revised_two_level_category }
      else
        format.html { render :edit }
        format.json { render json: @revised_two_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /revised_two_level_categories/1
  # DELETE /revised_two_level_categories/1.json
  def destroy
    @revised_two_level_category.destroy
    respond_to do |format|
      format.html { redirect_to revised_two_level_categories_url, notice: 'Revised two level category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_revised_two_level_category
      @revised_two_level_category = RevisedTwoLevelCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def revised_two_level_category_params
      params[:revised_two_level_category]
    end
end
