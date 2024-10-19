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
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def current_repository
    Repository.find(params[:repository_id])
  end
end
