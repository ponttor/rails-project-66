# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user, _options = {})
      auth_hash = {
        provider: 'github',
        info: {
          email: user.email,
          name: user.name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end

module ActiveStorage
  class Blob
    def self.fixture(filename:, **attributes)
      blob = new(
        filename:,
        key: generate_unique_secure_token
      )
      io = Rails.root.join("test/fixtures/files/#{filename}").open
      blob.unfurl(io)
      blob.assign_attributes(attributes)
      blob.upload_without_unfurling(io)

      blob.attributes.transform_values { |values| values.is_a?(Hash) ? values.to_json : values }.compact.to_json
    end
  end
end
