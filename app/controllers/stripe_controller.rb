class StripeController < ApplicationController

  def oauth
    #url, error = connector.oauth_url( redirect_uri: stripe_confirm_url )
    url, error = oauth_url(redirect_uri: 'http://informatk.com:3002/stripe/confirm/')

    if url.nil?
      flash[:error] = error
      redirect_to user_path(current_user)
    else
      redirect_to url
    end
  end

  # Confirm a connection to a Stripe account.
  # Only works on the currently logged in current_user.
  # See app/services/stripe_connect.rb for #verify! details.
  def confirm
    if params[:code]
      # If we got a 'code' parameter. Then the
      # connection was completed by the current_user.
      verify!(params[:code])

    elsif params[:error]
      # If we have an 'error' parameter, it's because the
      # current_user denied the connection request. Other errors
      # are handled at #oauth_url generation time.
      flash[:error] = "Authorization request denied."
    end

    redirect_to products_path
  end

  private

  def oauth_url(params)
    @client ||= OAuth2::Client.new(
      Rails.application.secrets.stripe_client_id,
      Rails.application.secrets.stripe_secret_key,
      {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
    ).auth_code

    url = @client.authorize_url(
      {
        scope: 'read_write',
        stripe_landing: 'login',
        stripe_user: {
          email: current_user.email
        }
      }.merge(params))

    # Make a request to this URL by hand before
    # redirecting the current_user there. This way we
    # can handle errors (other than access_denied, which
    # could come later).
    # See https://stripe.com/docs/connect/reference#get-authorize-errors
    begin
      response = RestClient.get url
        # If the request was successful, then we're all good to return
        # this URL.

    rescue => e
      # On the other hand, if the request failed, then
      # we can't send them to connect.
      json = JSON.parse(e.response.body) rescue nil
      if json && json['error']
        case json['error']

          # The application is configured incorrectly and
          # does not have the right Redirect URI
          when 'invalid_redirect_uri'
            return nil, <<-EOF
            Redirect URI is not setup correctly.
            Please see the <a href='#{Rails.configuration.github_url}/blob/master/README.markdown' target='_blank'>README</a>.
            EOF

          # Something else horrible happened? Network is down,
          # Stripe API is broken?...
          else
            return [nil, params[:error_description]]

        end
      end

      # If there was some problem parsing the body
      # or there's no 'error' parameter, then something
      # _really_ went wrong. So just blow up here.
      return [nil, "Unable to connect to Stripe. #{e.message}"]
    end

    [url, nil]
  end

  # Upon redirection back to this app, we'll have
  # a 'code' that we can use to get the access token
  # and other details about our connected current_user.
  # See app/controllers/users_controller.rb#confirm for counterpart.
  def verify!(code)
    @client ||= OAuth2::Client.new(
      Rails.application.secrets.stripe_client_id,
      Rails.application.secrets.stripe_secret_key,
      {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }
    ).auth_code
    data = @client.get_token(code, {
      headers: {
        'Authorization' => "Bearer #{Rails.application.secrets.stripe_secret_key}"
      }
    })

    seller = Seller.create(
      user: current_user,
      name: current_user.email,
      stripe_user_id: data.params['stripe_user_id'],
      publishable_key: data.params['stripe_publishable_key'],
      secret_key:data.token
    )

  end

  # Deauthorize the current_user. Straight-forward enough.
  # See app/controllers/users_controller.rb#deauthorize for counterpart.
  def deauthorize!
    response = RestClient.post(
      'https://connect.stripe.com/oauth/deauthorize',
      { client_id: Rails.application.secrets.stripe_client_id,
        stripe_user_id: current_user.stripe_user_id },
      { 'Authorization' => "Bearer #{Rails.application.secrets.stripe_secret_key}" }
    )
    user_id = JSON.parse(response.body)['stripe_user_id']

    deauthorized if response.code == 200 && user_id == current_user.stripe_user_id
  end

  # The actual deauthorization on our side consists
  # of 'forgetting' the now-invalid user_id, API keys, etc.
  # Used here in #deauthorize! as well as in the webhook handler:
  # app/controllers/hooks_controller.rb#stripe
  def deauthorized
    current_user.update_attributes(
      stripe_user_id: nil,
      secret_key: nil,
      publishable_key: nil,
      currency: nil
    )
  end

  # Get the default currency of the connected current_user.
  # All transactions will use this currency.
  def default_currency
    Stripe::Account.retrieve(current_user.stripe_user_id, current_user.secret_key).default_currency
  end

end
