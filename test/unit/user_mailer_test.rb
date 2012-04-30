require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer

  fixtures :users

  def setup
    ActionMailer::Base.deliveries = []
  end

  def test_welcome_email
    user = users(:default)

    UserMailer.deliver_welcome_email(user)

    assert !ActionMailer::Base.deliveries.empty?

    sent = ActionMailer::Base.deliveries.first

    assert_equal [user.email], sent.to
    assert sent.subject =~ /^Welcome/
    assert sent.body =~ /http:\/\/test.com\/session\/new/

  end
end

