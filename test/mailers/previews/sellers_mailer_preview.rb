# Preview all emails at http://localhost:3000/rails/mailers/sellers_mailer
class SellersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sellers_mailer/connect
  def connect
    SellersMailer.connect
  end

end
