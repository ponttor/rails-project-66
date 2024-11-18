# frozen_string_literal: true

class GithubWebhookService
  def self.create(repository_id)
    repository = Repository.find(repository_id)
    user_token = ENV.fetch('GITHUB_TOKEN', nil)
    # user_token = repository.user.token

    client = ApplicationContainer[:octokit_client].new access_token: user_token, auto_paginate: true
    url = Rails.application.routes.url_helpers.api_checks_url

    client.create_hook(
      repository.github_id,
      'web',
      {
        url:,
        content_type: 'json',
        insecure_ssl: '0'
      },
      {
        events: %w[push],
        active: true
      }
    )
  rescue Octokit::Error => e
    Rails.logger.error("Failed to create webhook: #{e.message}, #{e.backtrace}")
    raise
  end
end
