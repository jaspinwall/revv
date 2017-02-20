class PurchasesMailer < ApplicationMailer
  default from: 'notifications@revv.com'

  def thank_you(purchase)
    @purchase = purchase
    mail(to: @purchase.buyer.user.email, subject: 'Thank you for your order')
  end
end
