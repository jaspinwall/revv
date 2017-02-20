class Product < ApplicationRecord
  belongs_to :seller
  has_many :purchases, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_destroy do |product|
    throw(:abort) if CurrentScope.current_user.seller.id == product.seller.id
  end

end
