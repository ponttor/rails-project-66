# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: "#{Rails.application.class.module_parent_name}@checks.com"

  def failed
    @check = params[:check]
    repository = @check.repository
    @user = repository.user
    @repository_full_name = repository.full_name

    mail(to: @user.email, subject: t('.subject', repository_full_name: @repository_full_name))
  end
end
