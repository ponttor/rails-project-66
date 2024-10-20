# frozen_string_literal: true

module AuthConcern
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, flash: { warning: t('errors.auth') }
  end
end
