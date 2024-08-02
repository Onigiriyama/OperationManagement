require "test_helper"

class DirectsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get directs_new_url
    assert_response :success
  end

  test "should get create" do
    get directs_create_url
    assert_response :success
  end

  test "should get index" do
    get directs_index_url
    assert_response :success
  end
end
