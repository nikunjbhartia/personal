require 'test_helper'

class ProductsThreeLevelCategoriesControllerTest < ActionController::TestCase
  setup do
    @products_three_level_category = products_three_level_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products_three_level_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create products_three_level_category" do
    assert_difference('ProductsThreeLevelCategory.count') do
      post :create, products_three_level_category: {  }
    end

    assert_redirected_to products_three_level_category_path(assigns(:products_three_level_category))
  end

  test "should show products_three_level_category" do
    get :show, id: @products_three_level_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @products_three_level_category
    assert_response :success
  end

  test "should update products_three_level_category" do
    patch :update, id: @products_three_level_category, products_three_level_category: {  }
    assert_redirected_to products_three_level_category_path(assigns(:products_three_level_category))
  end

  test "should destroy products_three_level_category" do
    assert_difference('ProductsThreeLevelCategory.count', -1) do
      delete :destroy, id: @products_three_level_category
    end

    assert_redirected_to products_three_level_categories_path
  end
end
