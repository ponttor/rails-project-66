# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @check = Repository::Check.find(params[:id])
    authorize @check
  end

  def create
    @check = current_repository.checks.new
    authorize @check
    @check.save!

    LintService.new(@check, current_repository).perform_check
  rescue StandardError => e
    flash.now[:danger] = "Failed to perform check: #{e.message}"
    redirect_to repository_path(current_repository)
  end

  private

  def current_repository
    Repository.find(params[:repository_id])
  end
end
