require 'test_helper'

class SellersMailerTest < ActionMailer::TestCase
  test "connect" do
    mail = SellersMailer.connect
    assert_equal "Connect", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
