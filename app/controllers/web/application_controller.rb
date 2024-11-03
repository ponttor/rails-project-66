# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include AuthConcern
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from NotAuthenticatedError, with: :user_not_authenticated

    private

    def user_not_authorized
      redirect_to root_path, flash: { warning: t('errors.auth') }
    end

    def user_not_authenticated
      redirect_to root_path, alert: t('user_not_authenticated')
    end
  end
end
