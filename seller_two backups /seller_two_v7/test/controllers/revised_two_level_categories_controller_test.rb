require 'test_helper'

class RevisedTwoLevelCategoriesControllerTest < ActionController::TestCase
  setup do
    @revised_two_level_category = revised_two_level_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:revised_two_level_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create revised_two_level_category" do
    assert_difference('RevisedTwoLevelCategory.count') do
      post :create, revised_two_level_category: {  }
    end

    assert_redirected_to revised_two_level_category_path(assigns(:revised_two_level_category))
  end

  test "should show revised_two_level_category" do
    get :show, id: @revised_two_level_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @revised_two_level_category
    assert_response :success
  end

  test "should update revised_two_level_category" do
    patch :update, id: @revised_two_level_category, revised_two_level_category: {  }
    assert_redirected_to revised_two_level_category_path(assigns(:revised_two_level_category))
  end

  test "should destroy revised_two_level_category" do
    assert_difference('RevisedTwoLevelCategory.count', -1) do
      delete :destroy, id: @revised_two_level_category
    end

    assert_redirected_to revised_two_level_categories_path
  end
end
