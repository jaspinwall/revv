class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :buyer
  has_one :charge, dependent: :destroy

  after_create do |purchase|
    PurchasesMailer.thank_you(purchase).deliver_now
  end
end
