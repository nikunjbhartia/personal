require 'test_helper'

class ThreeLevelCategoriesControllerTest < ActionController::TestCase
  setup do
    @three_level_category = three_level_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:three_level_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create three_level_category" do
    assert_difference('ThreeLevelCategory.count') do
      post :create, three_level_category: {  }
    end

    assert_redirected_to three_level_category_path(assigns(:three_level_category))
  end

  test "should show three_level_category" do
    get :show, id: @three_level_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @three_level_category
    assert_response :success
  end

  test "should update three_level_category" do
    patch :update, id: @three_level_category, three_level_category: {  }
    assert_redirected_to three_level_category_path(assigns(:three_level_category))
  end

  test "should destroy three_level_category" do
    assert_difference('ThreeLevelCategory.count', -1) do
      delete :destroy, id: @three_level_category
    end

    assert_redirected_to three_level_categories_path
  end
end
