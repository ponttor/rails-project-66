# frozen_string_literal: true

module AuthConcern
  class NotAuthenticatedError < StandardError; end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def authenticate_user!
    return if signed_in?

    raise NotAuthenticatedError
  end
end
