# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    test 'check request' do
      post auth_request_path('github')
      assert_response :redirect
    end

    test 'check callback and logout' do
      mock_omni_auth(users(:one))

      get callback_auth_path('github')
      assert_redirected_to root_path
      assert signed_in?

      get auth_destroy_path
      assert_redirected_to root_path
      assert_not signed_in?
    end
  end
end
