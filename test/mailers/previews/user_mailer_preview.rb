class UserMailerPreview < ActionMailer::Preview
  def failed
    UserMailer.with(check: Repository::Check.first).failed
  end
end
