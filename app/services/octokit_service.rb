# frozen_string_literal: true

class OctokitService
  class << self
    def get_remote_repositories(current_user)
      client = get_client(current_user)
      client.repos
    end

    def get_repository_data(current_user, github_id)
      client = get_client(current_user)
      client.repo github_id.to_i
    end

    def get_client(current_user)
      ApplicationContainer[:octokit_client].new access_token: current_user.token, auto_paginate: true
    end

    def create_hook(repository_id)
      repository = Repository.find(repository_id)
      user_token = repository.user.token
      url = Rails.application.routes.url_helpers.checks_url

      client = ApplicationContainer[:octokit_client].new access_token: user_token, auto_paginate: true

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
end
