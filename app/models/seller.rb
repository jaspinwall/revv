class Seller < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  delegate :email, to: :user

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
end
