# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = current_user.repositories.find(params[:id])
    end

    def new
      @repository = Repository.new
      @repositories = OktokitService.get_remote_repositories(current_user)
    end

    def create
      return if repository_params[:github_id].blank?

      @repository = current_user.repositories.find_or_initialize_by(repository_params)
      repository_data = OktokitService.get_remote_repository(current_user, repository_params[:github_id])

      @repository.name = repository_data.name
      @repository.full_name = repository_data.full_name
      @repository.language = repository_data.language.downcase
      @repository.clone_url = repository_data.clone_url
      @repository.ssh_url = repository_data.ssh_url

      if @repository.save
        redirect_to repositories_url, flash: { success: t('repositories.flash.create') }
      else
        @repositories = OktokitService.get_remote_repositories(current_user)
        render :new, status: :unprocessable_entity
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
