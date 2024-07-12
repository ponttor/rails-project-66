# frozen_string_literal: true

module Web
  class ApplicationController < ApplicationController
    include AuthConcern
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      redirect_to root_path, flash: { warning: t('auth_error') }
    end
  end
end
