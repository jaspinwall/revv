class CreateSellers < ActiveRecord::Migration[5.0]
  def change
    create_table :sellers do |t|
      t.references :user, foreign_key: true
      t.string :publishable_key
      t.string :secret_key
      t.string :stripe_user_id

      t.timestamps
    end
  end
end
