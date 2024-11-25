# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  helper_method :signed_in?, :current_user

  include AuthConcern
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from NotAuthenticatedError, with: :not_authenticated

  private

  def not_authorized
    redirect_to root_path, flash: { warning: t('flash.application.not_authorized') }
  end

  def not_authenticated
    redirect_to root_path, flash: { warning: t('flash.application.not_authenticated') }
  end
end
