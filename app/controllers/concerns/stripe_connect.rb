module StripeConnect
  extend ActiveSupport::Concern

  def oauth_url(params)
    client = OAuth2::Client.new(
      Rails.application.secrets.stripe_client_id,
      Rails.application.secrets.stripe_secret_key,
      {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
    ).auth_code

    url = client.authorize_url(
      {
        scope: 'read_write',
        stripe_landing: 'login'
      }.merge(params))

    restclient_get(url)

    [url, nil]
  end

  def verify!(code)
    client = OAuth2::Client.new(
      Rails.application.secrets.stripe_client_id,
      Rails.application.secrets.stripe_secret_key,
      {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
    ).auth_code

    data = client.get_token(code, {
      headers: {
        'Authorization' => "Bearer #{Rails.application.secrets.stripe_secret_key}"
      }
    })

    n = current_user.email.index('@') - 1
    seller_name = current_user.email[0..n]

    Seller.create(
      user: current_user,
      name: seller_name,
      stripe_user_id: data.params['stripe_user_id'],
      publishable_key: data.params['stripe_publishable_key'],
      secret_key: data.token
    )
  end

  def restclient_get(url)
    RestClient.get url
  rescue => e
    json = JSON.parse(e.response.body) rescue nil
    if json && json['error']
      case json['error']
        when 'invalid_redirect_uri'
          return nil, 'Redirect URI is not setup correctly.'
        else
          return [nil, params[:error_description]]
      end
    end
    return [nil, "Unable to connect to Stripe. #{e.message}"]
  end


end