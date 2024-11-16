# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: "#{Rails.application.class.module_parent_name}@checks.com"

  def failed
    @user = repository.user
    @check = params[:check]
    repository = @check.repositorysitory
    @repository_full_name = "#{repository.owner_name}/#{repository.repository_name}"

    mail(to: @user.email, subject: t('.subject', repository_full_name: @repository_full_name))
  end
end
