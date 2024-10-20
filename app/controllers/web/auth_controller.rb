# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      existing_user = User.find_or_create_by(email: auth[:info][:email])
      if existing_user.persisted?
        sign_in existing_user

        existing_user.nickname = auth[:info][:nickname]
        existing_user.name = auth[:info][:name]
        existing_user.email = auth[:info][:email]
        existing_user.image_url = auth[:info][:image]
        existing_user.token = auth[:credentials][:token] if auth[:credentials]

        existing_user.save

        redirect_to root_path, flash: { success: t('auth.success') }
      else
        redirect_to root_path, flash: { danger: t('auth.error') }
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, flash: { success: t('auth.destroy') }
    end

    private

    def auth
      request.env['omniauth.auth']
    end

    def sign_in(user)
      session[:user_id] = user.id
    end
  end
end
