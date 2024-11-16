# frozen_string_literal: true

class LintCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id, repository_id)
    check = Repository::Check.find_by(id: check_id)
    repository = Repository.find_by(id: repository_id)

    return if check.nil? || repository.nil?

    LintService.new(check, repository).perform_check
  rescue StandardError => e
    check.fail!
    Rails.logger.error("Lint check failed for repository #{repository.id}: #{e.message}")
  end
end
