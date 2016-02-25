require 'test_helper'

class MasterCategoryMappingControllersControllerTest < ActionController::TestCase
  setup do
    @master_category_mapping_controller = master_category_mapping_controllers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_category_mapping_controllers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_category_mapping_controller" do
    assert_difference('MasterCategoryMappingController.count') do
      post :create, master_category_mapping_controller: {  }
    end

    assert_redirected_to master_category_mapping_controller_path(assigns(:master_category_mapping_controller))
  end

  test "should show master_category_mapping_controller" do
    get :show, id: @master_category_mapping_controller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @master_category_mapping_controller
    assert_response :success
  end

  test "should update master_category_mapping_controller" do
    patch :update, id: @master_category_mapping_controller, master_category_mapping_controller: {  }
    assert_redirected_to master_category_mapping_controller_path(assigns(:master_category_mapping_controller))
  end

  test "should destroy master_category_mapping_controller" do
    assert_difference('MasterCategoryMappingController.count', -1) do
      delete :destroy, id: @master_category_mapping_controller
    end

    assert_redirected_to master_category_mapping_controllers_path
  end
end
