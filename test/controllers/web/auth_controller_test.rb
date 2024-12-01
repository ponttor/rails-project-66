# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'check request' do
      post auth_request_path('github')
      assert_response :redirect
    end

    test 'check callback' do
      mock_omni_auth(users(:one))

      get callback_auth_path('github')
      assert_redirected_to root_path
      assert signed_in?
    end

    test 'check logout' do
      user = users(:one)
      sign_in(user)

      mock_omni_auth(users(:one))

      get auth_destroy_path

      assert_redirected_to root_path
      assert_not signed_in?
    end
  end
end
