# frozen_string_literal: true

require 'test_helper'

module Web
  class WelcomeControllerTest < ActionDispatch::IntegrationTest
    test 'get index' do
      get root_url

      assert_response :success
    end
  end
end
