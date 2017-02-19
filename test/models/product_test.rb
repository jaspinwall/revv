require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'xyz@work.com')
    @seller = Seller.create(user: @user, name: 'ACME')
  end

  test 'success product create' do
    assert_difference 'Product.count' do
      product = Product.create(seller: @seller, name: 'car', price: 10)
      assert_empty product.errors
    end
  end

  test 'fails without seller' do
    assert_difference 'Product.count', 0 do
      product = Product.create( name: 'car', price: 10)
      assert_includes product.errors.messages[:seller], 'must exist'
    end
  end

  test 'fails product without name' do
    assert_difference 'Product.count', 0 do
      product = Product.create(seller: @seller, price: 10)
      assert product.errors.messages[:name].include?("can't be blank")
    end
  end

  test 'fails product with short name' do
    assert_difference 'Product.count', 0 do
      product = Product.create(seller: @seller, name: 'c', price: 10)
      assert_includes product.errors.messages[:name], 'is too short (minimum is 2 characters)'
    end
  end

  test 'fails product without price' do
    assert_difference 'Product.count', 0 do
      product = Product.create(seller: @seller, name: 'car')
      assert_includes product.errors.messages[:price], "can't be blank"
    end
  end

  test 'fails product with price not number' do
    assert_difference 'Product.count', 0 do
      product = Product.create(seller: @seller, name: 'car', price: 'abc')
      puts product.errors.messages
      assert_includes  product.errors.messages[:price], "is not a number"
    end
  end
end
