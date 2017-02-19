json.extract! seller, :id, :user_id, :publishable_key, :secret_key, :stripe_user_id, :created_at, :updated_at
json.url seller_url(seller, format: :json)