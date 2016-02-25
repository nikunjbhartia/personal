require 'test_helper'

class MasterCategoryMappingsControllerTest < ActionController::TestCase
  setup do
    @master_category_mapping = master_category_mappings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_category_mappings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_category_mapping" do
    assert_difference('MasterCategoryMapping.count') do
      post :create, master_category_mapping: {  }
    end

    assert_redirected_to master_category_mapping_path(assigns(:master_category_mapping))
  end

  test "should show master_category_mapping" do
    get :show, id: @master_category_mapping
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_category_mapping
    assert_response :success
  end

  test "should update master_category_mapping" do
    patch :update, id: @master_category_mapping, master_category_mapping: {  }
    assert_redirected_to master_category_mapping_path(assigns(:master_category_mapping))
  end

  test "should destroy master_category_mapping" do
    assert_difference('MasterCategoryMapping.count', -1) do
      delete :destroy, id: @master_category_mapping
    end

    assert_redirected_to master_category_mappings_path
  end
end
