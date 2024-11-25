# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories
    authorize Repository
  end

  def show
    @repository = current_user.repositories.find(params[:id])
    authorize @repository
  end

  def new
    @repository = Repository.new
    authorize @repository
    @repositories = OctokitService.get_remote_repositories(current_user)
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by(repository_params)
    authorize @repository

    set_repository_data
    @repository.save!

    GithubWebhookService.create(@repository.id)
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

  def set_repository_data
    repository_data = OctokitService.get_repository_data(current_user, repository_params[:github_id])

    assign_repository_data(repository_data)
  end

  def assign_repository_data(repository_data)
    @repository.name = repository_data[:name]
    @repository.ssh_url = repository_data[:ssh_url]
    @repository.full_name = repository_data[:full_name]
    @repository.clone_url = repository_data[:clone_url]
    @repository.language = repository_data[:language].downcase
  end
end
