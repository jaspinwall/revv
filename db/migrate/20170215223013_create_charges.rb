class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.references :purchase, foreign_key: true
      t.string :application_fee
      t.string :source

      t.timestamps
    end
  end
end
