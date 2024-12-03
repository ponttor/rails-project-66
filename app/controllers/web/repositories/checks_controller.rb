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

    LintCheckJob.perform_later(@check.id)
    redirect_to current_repository, flash: { success: t('flash.checks.create') }
  rescue StandardError => e
    @check.fail!
    UserMailer.with(check: @check).failed.deliver_later
    flash[:danger] = t('flash.checks.create_error', message: e.message)
    redirect_to repository_path(current_repository)
  end

  private

  def current_repository
    Repository.find(params[:repository_id])
  end
end
