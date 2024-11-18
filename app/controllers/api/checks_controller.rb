# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  # Константы
  GITHUB_EVENT_HEADER = 'X-GitHub-Event'
  PING_EVENT = 'ping'
  PUSH_EVENT = 'push'

  def create
    event_type = request.headers[GITHUB_EVENT_HEADER]

    case event_type
    when PING_EVENT
      handle_ping_event
    when PUSH_EVENT
      handle_push_event
    else
      render json: { error: t('webhooks.errors.event_not_implemented') }, status: :not_implemented
    end
  end

  private

  def handle_ping_event
    render json: { message: 'Ok', application: Rails.application.class.module_parent_name }, status: :ok
  end

  def handle_push_event
    repository = Repository.find_by(github_id: repository_params[:id])

    return render json: { error: t('webhooks.errors.repository_not_found') }, status: :not_found if repository.nil?
    return render json: { error: t('webhooks.errors.pending_check_exists') }, status: :conflict if repository.checks.last&.pending?

    check = repository.checks.new
    if perform_lint_check(check, repository)
      render json: { message: t('webhooks.messages.check_created_successfully') }, status: :ok
    else
      render json: { error: t('webhooks.errors.lint_service_failed') }, status: :unprocessable_entity
    end
  end

  def perform_lint_check(check, repository)
    check.save!
    LintCheckJob.perform_later(check.id, repository.id)
    true
  rescue StandardError
    check.mark_as_failed!
    false
  end

  def repository_params
    params.require(:repository).permit(:id)
  end
end
