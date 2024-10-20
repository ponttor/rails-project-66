# frozen_string_literal: true

class OktokitService
  class << self
    def get_remote_repositories(current_user)
      client = get_client(current_user)
      client.repos
    end

    def get_remote_repository(current_user, github_id)
      client = get_client(current_user)
      client.repo github_id.to_i
    end

    def get_client(current_user)
      Octokit::Client.new access_token: current_user.token, auto_paginate: true
    end
  end
end
