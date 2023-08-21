require "test_helper"

class GroupingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get groupings_create_url
    assert_response :success
  end

  test "should get destroy" do
    get groupings_destroy_url
    assert_response :success
  end
end
