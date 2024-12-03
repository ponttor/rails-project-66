# frozen_string_literal: true

class LintCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)

    return if check.nil?

    LintService.new(check).perform_check
    UserMailer.with(check:).failed.deliver_later unless check.passed
  rescue StandardError => e
    check.fail!
    Rails.logger.error("Lint check failed for repository #{check.repository.id}: #{e.message}")
  end
end
