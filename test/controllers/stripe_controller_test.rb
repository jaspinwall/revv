require 'test_helper'

class StripeControllerTest < ActionDispatch::IntegrationTest
  test "should get oauth" do
    get stripe_oauth_url
    assert_response :success
  end

  test "should get confirm" do
    get stripe_confirm_url
    assert_response :success
  end

  test "should get oauth_url" do
    get stripe_oauth_url_url
    assert_response :success
  end

  test "should get verify!" do
    get stripe_verify!_url
    assert_response :success
  end

end
