class StripeController < ApplicationController
  include StripeConnect

  def oauth
    url, error = oauth_url(redirect_uri: 'http://173.66.176.122:3000/stripe/confirm/')

    if url.nil?
      flash[:error] = error
      redirect_to products_path
    else
      redirect_to url
    end
  end

  def confirm
    if params[:code]
      verify!(params[:code])
    elsif params[:error]
      flash[:error] = "Authorization request denied."
    else
      flash[:error] = "Unknown confirmation error"
    end

    redirect_to products_path
  end

end
