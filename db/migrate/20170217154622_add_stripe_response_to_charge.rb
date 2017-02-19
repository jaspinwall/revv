class AddStripeResponseToCharge < ActiveRecord::Migration[5.0]
  def change
    add_column :charges, :stripe_response, :text
  end
end
