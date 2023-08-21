require "test_helper"

class SesiredHolidaysControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sesired_holidays_new_url
    assert_response :success
  end

  test "should get create" do
    get sesired_holidays_create_url
    assert_response :success
  end

  test "should get destroy" do
    get sesired_holidays_destroy_url
    assert_response :success
  end
end
