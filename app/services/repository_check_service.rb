# frozen_string_literal: true

class RepositoryCheckService
  REPOSITORY_CLONE_PATH = 'tmp/git_clones/'

  def initialize(check, repository)
    @check = check
    @repository = repository
    @repository_path = "#{REPOSITORY_CLONE_PATH}#{repository.name}/"
  end

  def perform_check
    fetch_repository
    run_lint_check
    finalize_check
  rescue StandardError => e
    @check.fail!
    raise e
  end

  private

  def fetch_repository
    @check.start_fetch!
    commit_id = GitRepositoryService.new(@repository, @repository_path).fetch_repository

    @check.update(commit_id:)
    @check.complete_fetch!
  end
  # @check.commit_id = fetch_repo_data.call(@repository, @repository_path)

  def run_lint_check
    @check.start_check!
    json_string = RubyLintService.new(@repository_path).perform_ruby_lint
    @check.complete_check!

    parse_results(json_string)
  end

  def parse_results(json_string)
    @check.start_parse!
    check_results, offenses_count = RubyLintService.parse_lint_results(@repository_path, json_string)
    @check.complete_parse!

    @check.update!(
      check_results:,
      offenses_count:,
      passed: offenses_count.zero?
    )
  end

  def finalize_check
    Rails.logger.debug '********************************'
    Rails.logger.debug @check
    Rails.logger.debug '********************************'
    @check.finish!
  end
end
