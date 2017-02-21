class Charge < ApplicationRecord
  monetize :application_fee_cents
  belongs_to :purchase
  serialize :stripe_response, JSON
end
