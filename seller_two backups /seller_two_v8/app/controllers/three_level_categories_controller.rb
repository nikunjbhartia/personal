class ThreeLevelCategoriesController < ApplicationController
  before_action :set_three_level_category, only: [:show, :edit, :update, :destroy]
  layout 'manage'
  # GET /three_level_categories
  # GET /three_level_categories.json
  def index
    @three_level_categories = ThreeLevelCategory.all
  end

  # GET /three_level_categories/1
  # GET /three_level_categories/1.json
  def show
  end

  # GET /three_level_categories/new
  def new
    @three_level_category = ThreeLevelCategory.new
  end

  # GET /three_level_categories/1/edit
  def edit
  end

  # POST /three_level_categories
  # POST /three_level_categories.json
  def create
    @three_level_category = ThreeLevelCategory.new(three_level_category_params)

    respond_to do |format|
      if @three_level_category.save
        format.html { redirect_to @three_level_category, notice: 'Three level category was successfully created.' }
        format.json { render :show, status: :created, location: @three_level_category }
      else
        format.html { render :new }
        format.json { render json: @three_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /three_level_categories/1
  # PATCH/PUT /three_level_categories/1.json
  def update
    respond_to do |format|
      if @three_level_category.update(three_level_category_params)
        format.html { redirect_to @three_level_category, notice: 'Three level category was successfully updated.' }
        format.json { render :show, status: :ok, location: @three_level_category }
      else
        format.html { render :edit }
        format.json { render json: @three_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /three_level_categories/1
  # DELETE /three_level_categories/1.json
  def destroy
    @three_level_category.destroy
    respond_to do |format|
      format.html { redirect_to three_level_categories_url, notice: 'Three level category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_three_level_category
      @three_level_category = ThreeLevelCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def three_level_category_params
      params[:three_level_category]
    end
end
