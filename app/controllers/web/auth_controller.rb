# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  OMNIAUTH_AUTH_KEY = 'omniauth.auth'

  def callback
    redirect_to root_path if signed_in?

    user = User.find_or_initialize_by(email: auth_params[:info][:email])

    return redirect_to root_path, flash: { danger: t('flash.auth.error') } unless update_user_info(user)

    sign_in user
    redirect_to root_path, flash: { success: t('flash.auth.success') }
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { success: t('flash.auth.destroy') }
  end

  private

  def auth_params
    request.env[OMNIAUTH_AUTH_KEY]
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def update_user_info(user)
    user.name = auth_params[:info][:name]
    user.email = auth_params[:info][:email]
    user.image_url = auth_params[:info][:image]
    user.nickname = auth_params[:info][:nickname]
    user.token = auth_params[:credentials][:token] if auth_params[:credentials]

    user.save
  end
end
