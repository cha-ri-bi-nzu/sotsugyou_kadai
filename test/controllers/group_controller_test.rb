require "test_helper"

class GroupControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get group_new_url
    assert_response :success
  end

  test "should get create" do
    get group_create_url
    assert_response :success
  end

  test "should get show" do
    get group_show_url
    assert_response :success
  end

  test "should get edit" do
    get group_edit_url
    assert_response :success
  end

  test "should get update" do
    get group_update_url
    assert_response :success
  end

  test "should get destroy" do
    get group_destroy_url
    assert_response :success
  end
end