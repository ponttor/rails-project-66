# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'check github auth' do
      post auth_request_path('github')
      assert_response :redirect
    end

    test 'create' do
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.first_name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')
      assert_response :redirect

      user = User.find_by(email: auth_hash[:info][:email].downcase)

      assert user
      assert signed_in?
    end

    test 'destroy' do
      @user = users(:one)
      sign_in(@user)
      get auth_destroy_url

      assert_redirected_to root_url
      assert_not signed_in?
    end
  end
end
