class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :buyer
  has_one :charge, dependent: :destroy
end
