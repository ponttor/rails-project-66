# frozen_string_literal: true

class SetupRepositoryJob < ApplicationJob
  queue_as :default

  def perform(github_id)
    repository = Repository.find_by(github_id:)
    update_repository_data(repository)

    OctokitService.create_hook(repository.id)
  rescue StandardError => e
    Rails.logger.error("Failed to setup repository: #{e.message}")
    raise
  end

  private

  def update_repository_data(repository)
    repository_data = OctokitService.get_repository_data(repository.user, repository.github_id)
    assign_repository_data(repository, repository_data)

    repository.save!
  end

  def assign_repository_data(repository, repository_data)
    repository.name = repository_data[:name]
    repository.ssh_url = repository_data[:ssh_url]
    repository.full_name = repository_data[:full_name]
    repository.clone_url = repository_data[:clone_url]
    repository.language = repository_data[:language]&.downcase || repository_data[:source][:language]&.downcase

    repository
  end
end
