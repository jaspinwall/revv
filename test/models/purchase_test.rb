require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  def setup
    @user_seller = User.create(email: 'xyz@work.com')
    @seller = Seller.create(user: @user_seller, name: 'ACME')
    @product = Product.create(seller: @seller, name: 'car', price: 10)

    @user_buyer = User.create(email: 'john@home.com')
    @buyer = Buyer.create(user: @user_buyer, name: 'John Smith')
  end

  test 'success purchase create' do
    assert_difference 'Purchase.count' do
      purchase = Purchase.create(product: @product, buyer: @buyer)
      assert_empty purchase.errors
    end
  end

  test 'fails without buyer' do
    assert_difference 'Purchase.count', 0 do
      purchase = Purchase.create(product: @product)
      assert_includes purchase.errors.messages[:buyer], "must exist"
    end
  end

  test 'fails without product' do
    assert_difference 'Purchase.count', 0 do
      purchase = Purchase.create(buyer: @buyer)
      puts purchase.errors.messages
      assert_includes purchase.errors.messages[:product], "must exist"
    end
  end

end
