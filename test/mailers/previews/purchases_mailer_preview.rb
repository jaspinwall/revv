# Preview all emails at http://localhost:3000/rails/mailers/purchases_mailer
class PurchasesMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/purchases_mailer/thank_you
  def thank_you
    PurchasesMailer.thank_you
  end

end
