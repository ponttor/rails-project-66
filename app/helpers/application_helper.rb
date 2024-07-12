# frozen_string_literal: true

module ApplicationHelper
  def signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
