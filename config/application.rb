# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsProject66
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.autoload_paths << Rails.root.join('lib')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
    I18n.default_locale = :ru
    routes.default_url_options = { host: ENV.fetch('BASE_URL', nil) }
    # config.active_job.queue_adapter = :sidekiq
    # config.active_job.queue_adapter = :async
  end
end
