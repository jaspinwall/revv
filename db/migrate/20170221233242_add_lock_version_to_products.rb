class AddLockVersionToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :lock_version, :integer
  end
end
