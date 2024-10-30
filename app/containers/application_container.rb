# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    #test_container
  else
    register :octokit_client, -> { Octokit::Client }
    register :fetch_repository, ->(repository, _path) { GitCloneService.new(repository, temp_repo_path).fetch_repository }
    register :lint_check, ->(temp_repo_path) { RubyLintService.new(temp_repo_path).perform_ruby_lint }
  end
end
