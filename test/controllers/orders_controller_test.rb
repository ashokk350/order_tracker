require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get csv" do
    get orders_csv_url
    assert_response :success
  end
end
