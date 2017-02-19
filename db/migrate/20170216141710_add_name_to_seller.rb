class AddNameToSeller < ActiveRecord::Migration[5.0]
  def change
    add_column :sellers, :name, :string
  end
end
