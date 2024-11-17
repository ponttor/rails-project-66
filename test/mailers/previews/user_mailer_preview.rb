# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def failed
    UserMailer.with(check: Repository::Check.first).failed
  end
end
