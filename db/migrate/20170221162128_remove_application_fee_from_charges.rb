class RemoveApplicationFeeFromCharges < ActiveRecord::Migration[5.0]
  def change
    remove_column :charges, :application_fee, :string
  end
end
