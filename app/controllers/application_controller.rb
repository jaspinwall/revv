class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  before_action do
    CurrentScope.current_user = current_user
  end
end
