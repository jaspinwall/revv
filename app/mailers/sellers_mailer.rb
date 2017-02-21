class SellersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sellers_mailer.connect.subject
  #
  def connect(seller)
    @seller = seller

    mail to: seller.user.email
  end
end
