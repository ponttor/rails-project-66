# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  def show
    @check = Repository::Check.find(params[:id])
  end

  def create
    @check = current_repository.checks.new
    @check.save!

    RepositoryCheckService.new(@check, current_repository).perform_check
  rescue StandardError => e
    flash.now[:danger] = "Failed to perform check: #{e.message}"
    redirect_to repository_path(current_repository)
  end

  private

  def current_repository
    Repository.find(params[:repository_id])
  end
end
