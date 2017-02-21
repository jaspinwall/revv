class Seller < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  delegate :email, to: :user

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }

  after_create do |seller|
    SellersMailer.connect(seller).deliver_now
  end
end
