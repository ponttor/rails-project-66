class RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])
  end

  def new
  end

  def create
  end
end
