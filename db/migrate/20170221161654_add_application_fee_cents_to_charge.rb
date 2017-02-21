class AddApplicationFeeCentsToCharge < ActiveRecord::Migration[5.0]
  def change
    add_column :charges, :application_fee_cents, :integer
  end
end
