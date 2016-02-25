class ProductsThreeLevelCategoriesController < ApplicationController
  before_action :set_products_three_level_category, only: [:show, :edit, :update, :destroy]
  layout 'manage'
  # GET /products_three_level_categories
  # GET /products_three_level_categories.json
  def index
    @products_three_level_categories = ProductsThreeLevelCategory.all
  end

  # GET /products_three_level_categories/1
  # GET /products_three_level_categories/1.json
  def show
  end

  # GET /products_three_level_categories/new
  def new
    @products_three_level_category = ProductsThreeLevelCategory.new
  end

  # GET /products_three_level_categories/1/edit
  def edit
  end

  # POST /products_three_level_categories
  # POST /products_three_level_categories.json
  def create
    @products_three_level_category = ProductsThreeLevelCategory.new(products_three_level_category_params)

    respond_to do |format|
      if @products_three_level_category.save
        format.html { redirect_to @products_three_level_category, notice: 'Products three level category was successfully created.' }
        format.json { render :show, status: :created, location: @products_three_level_category }
      else
        format.html { render :new }
        format.json { render json: @products_three_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products_three_level_categories/1
  # PATCH/PUT /products_three_level_categories/1.json
  def update
    respond_to do |format|
      if @products_three_level_category.update(products_three_level_category_params)
        format.html { redirect_to @products_three_level_category, notice: 'Products three level category was successfully updated.' }
        format.json { render :show, status: :ok, location: @products_three_level_category }
      else
        format.html { render :edit }
        format.json { render json: @products_three_level_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products_three_level_categories/1
  # DELETE /products_three_level_categories/1.json
  def destroy
    @products_three_level_category.destroy
    respond_to do |format|
      format.html { redirect_to products_three_level_categories_url, notice: 'Products three level category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_products_three_level_category
      @products_three_level_category = ProductsThreeLevelCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def products_three_level_category_params
      params[:products_three_level_category]
    end
end
