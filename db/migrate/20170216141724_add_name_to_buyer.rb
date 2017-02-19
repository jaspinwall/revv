class AddNameToBuyer < ActiveRecord::Migration[5.0]
  def change
    add_column :buyers, :name, :string
  end
end
