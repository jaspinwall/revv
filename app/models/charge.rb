class Charge < ApplicationRecord
  belongs_to :purchase
  serialize :stripe_response, JSON
end
