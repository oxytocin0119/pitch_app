require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウントの有効化", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    #assert_match user.name,               mail.body.encoded
    assert_match user.name,               mail.text_part.body.decoded
    assert_match user.name,               mail.text_part.body.encoded#
    assert_match user.name,               mail.html_part.body.decoded
    assert_match user.name,               mail.html_part.body.encoded#
    assert_match user.activation_token,   mail.text_part.body.decoded
    assert_match user.activation_token,   mail.html_part.body.decoded
    assert_match CGI.escape(user.email),  mail.text_part.body.decoded
    assert_match CGI.escape(user.email),  mail.html_part.body.decoded
  end
end
