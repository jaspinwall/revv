require 'test_helper'

class SellerTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'xyz@work.com')
  end

  test 'success seller create' do
    assert_difference 'Seller.count' do
      seller = Seller.create(user: @user, name: 'ACME')
      assert_empty seller.errors
    end
  end

  test 'fails without name' do
    assert_difference 'Seller.count', 0 do
      seller = Seller.create(user: @user)
      assert_includes seller.errors.messages[:name], "can't be blank"
    end
  end

  test 'fails with short name' do
    assert_difference 'Seller.count', 0 do
      seller = Seller.create(user: @user, name: 'A')
      assert_includes seller.errors.messages[:name], "is too short (minimum is 2 characters)"
    end
  end

  test 'fails without user' do
    assert_difference 'Seller.count', 0 do
      seller = Seller.create(name: 'ACME')
      puts seller.errors.messages
      assert_includes seller.errors.messages[:name], "can't be blank"
    end
  end

end
