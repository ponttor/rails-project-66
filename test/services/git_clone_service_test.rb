# frozen_string_literal: true

require_relative '../../lib/application_container'
require 'test_helper'
require 'minitest/mock'

class GitCloneServiceTest < ActiveSupport::TestCase
  TEST_COMMIT_ID = '0078700'

  def setup
    @repository = Struct.new(:clone_url, :full_name).new('https://github.com/test/repo.git', 'test/repo')
    @path = 'test_repo_clone'
    @service = GitCloneService.new(@repository, @path)
  end

  def test_fetch_repository_successfully_clones_repository_and_fetches_last_commit_id
    mock_run_programm = Minitest::Mock.new
    mock_run_programm.expect :call, ["Cloning into 'test_repo_clone'...\n", 0], [String]
    @service.stub :run_programm, [' ', 0] do
      stub_request(:get, "#{GitCloneService::GITHUB_API_BASE_URL}#{@repository.full_name}/commits")
        .to_return(
          body: [{ 'sha' => "#{TEST_COMMIT_ID}999" }].to_json,
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )

      commit_id = @service.fetch_repository

      assert_equal TEST_COMMIT_ID, commit_id
    end
  end

  def test_fetch_repository_raises_error_when_clone_fails
    mock_run_programm = Minitest::Mock.new
    mock_run_programm.expect :call, ['Error: failed to clone repository', 1], [String]

    @service.stub :run_programm, mock_run_programm do
      error = assert_raises(GitCloneService::GitFetchError) do
        @service.fetch_repository
      end
      assert_match(/Failed to clone repository/, error.message)
      mock_run_programm.verify
    end
  end
end
