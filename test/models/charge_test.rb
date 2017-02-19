require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  def setup
    @user_seller = User.create(email: 'xyz@work.com')
    @seller = Seller.create(user: @user_seller, name: 'ACME')
    @product = Product.create(seller: @seller, name: 'car', price: 10)

    @user_buyer = User.create(email: 'john@home.com')
    @buyer = Buyer.create(user: @user_buyer, name: 'John Smith')

    @purchase = Purchase.create(product: @product, buyer: @buyer)
  end

  test 'success charge create' do
    assert_difference 'Charge.count' do
      purchase = Charge.create(purchase: @purchase)
      assert_empty purchase.errors
    end
  end

  test 'fails without purchase' do
    assert_difference 'Charge.count', 0 do
      charge = Charge.create
      assert_includes charge.errors.messages[:purchase], "must exist"
    end
  end

end
