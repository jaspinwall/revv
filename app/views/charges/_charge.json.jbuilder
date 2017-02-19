json.extract! charge, :id, :purchase_id, :application_fee, :source, :created_at, :updated_at
json.url charge_url(charge, format: :json)