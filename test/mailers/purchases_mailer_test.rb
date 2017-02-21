require 'test_helper'

class PurchasesMailerTest < ActionMailer::TestCase
  test "thank_you" do
    mail = PurchasesMailer.thank_you
    assert_equal "Thank you", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
