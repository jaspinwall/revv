class Product < ApplicationRecord
  belongs_to :seller
  has_many :purchases, dependent: :destroy

  monetize :price_cents

  validates :name, presence: true, uniqueness: true, length: {minimum: 2}
  validates :price_cents, presence: true, numericality: {only_integer: true, greater_than: 0}

  after_create do |product|
    seller = CurrentScope.current_user.seller
    if seller.present?
      product.update(seller_id: seller.id)
    else
      product.errors.add(:seller, :bad_seller, message: 'You cannot update a product without login')
      throw(:abort)
    end
  end

  before_update do |product|
    unless CurrentScope.current_user.seller == product.seller
      product.errors.add(:seller, :bad_seller, message: 'You cannot update a product from another seller')
      throw(:abort)
    end
  end

  before_destroy do |product|
    throw(:abort) unless CurrentScope.current_user.seller == product.seller
  end

  def self.allowed_to_create?
    CurrentScope.current_user.seller.present?
  end
end
