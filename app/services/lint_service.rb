# frozen_string_literal: true

class LintService
  class UnsupportedLanguageError < StandardError; end

  RUBY = 'ruby'
  JAVASCRIPT = 'javascript'
  REPOSITORY_CLONE_PATH = 'tmp/git_clones/'

  def initialize(check)
    @check = check
    @repository = check.repository
    @repository_path = "#{REPOSITORY_CLONE_PATH}#{check.repository.name}/"
  end

  def perform_check
    fetch_repository
    run_lint_check
    finalize_check
  end

  private

  def fetch_repository
    @check.start_fetch!
    commit_id = ApplicationContainer[:fetch_repository].new(@repository, @repository_path).fetch_repository

    @check.update(commit_id:)
    @check.complete_fetch!
  end

  def run_lint_check
    @check.start_check!
    lint_service = choose_lint_service
    json_string = lint_service.perform_lint(@repository_path)
    @check.complete_check!
    parse_results(json_string, lint_service)
  end

  def parse_results(json_string, lint_service)
    @check.start_parse!

    check_results, offenses_count = lint_service.parse_lint_results(json_string, @repository_path)
    @check.complete_parse!
    @check.update!(
      check_results:,
      offenses_count:,
      passed: offenses_count.zero?
    )
  end

  def finalize_check
    @check.finish!
  end

  def choose_lint_service
    language = @repository.language&.downcase
    case language
    when RUBY
      Linter::RubyLintService
    when JAVASCRIPT
      Linter::JavascriptLintService
    else
      raise UnsupportedLanguageError, "Unsupported language: #{language}"
    end
  end
end
