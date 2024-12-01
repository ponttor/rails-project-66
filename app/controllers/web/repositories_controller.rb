# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])
  end

  def new
    @repository = Repository.new
    @repositories = OctokitService.get_remote_repositories(current_user)
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by(repository_params)

    SetupRepositoryJob.perform_later(repository_params[:github_id]) unless @repository.persisted?
    @repository.save!
    redirect_to repositories_path, flash: { info: t('flash.repositories.create') }
  rescue StandardError => _e
    flash.now[:danger] = t('flash.repositories.create_error')
    @repositories = OctokitService.get_remote_repositories(current_user)
    render :new, status: :unprocessable_entity
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
