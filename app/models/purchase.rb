class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :buyer
  has_one :charge, dependent: :destroy

  # comment
  after_create do |purchase|
    PurchasesMailer.thank_you(purchase).deliver_now
  end
end
