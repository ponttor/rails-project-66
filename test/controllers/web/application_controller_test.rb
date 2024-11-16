# frozen_string_literal: true

require 'test_helper'

module Web
  class ApplicationControllerTest < ActionDispatch::IntegrationTest
    test 'successful request for authorized user' do
      @user = users(:one)
      sign_in(@user)

      repository = repositories(:ruby)

      get repository_path(repository)
      assert_response :success
    end

    test 'handles NotAuthenticatedError' do
      get repositories_path

      assert_redirected_to root_path
      assert_equal flash[:warning], I18n.t('flash.application.not_authenticated')
    end
  end
end
