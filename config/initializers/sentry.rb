# frozen_string_literal: true

unless Rails.env.test?
  Sentry.init do |config|
    config.dsn = ENV.fetch('SENTRY_DSN', nil)
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.environment = 'production'
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 1.0
    # or
    config.traces_sampler = lambda do |_context|
      true
    end
    # Set profiles_sample_rate to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    config.profiles_sample_rate = 1.0
  end
end
