require 'test_helper'

class ConnectControllerTest < ActionDispatch::IntegrationTest
  test "should get oauth" do
    get connect_oauth_url
    assert_response :success
  end

  test "should get confirm" do
    get connect_confirm_url
    assert_response :success
  end

  test "should get oauth_url" do
    get connect_oauth_url_url
    assert_response :success
  end

  test "should get verify!" do
    get connect_verify!_url
    assert_response :success
  end

end
