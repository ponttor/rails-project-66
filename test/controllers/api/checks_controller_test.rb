# frozen_string_literal: true

require 'test_helper'

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repository = repositories(:ruby)
      @github_id = @repository.github_id
    end

    test 'push-event with invalid repository id' do
      post api_checks_url, params: { repository: { id: 777 } }, headers: { 'X-GitHub-Event': 'push' }
      assert_response :not_found
      assert_not Repository::Check.exists?(repository_id: 777)
    end

    test 'push-event with valid repository id' do
      @repository.checks.destroy_all
      assert_difference('@repository.checks.count', 1) do
        post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'push' }
      end
      assert_response :ok

      @repository.checks.reload
      last_check = @repository.checks.last

      assert_equal 'finished', last_check.aasm_state
      assert last_check.passed?
      assert last_check.offenses_count.is_a?(Integer)
      assert_not_nil last_check.check_results
    end

    test 'ping-event' do
      last_check = @repository.checks.last
      post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'ping' }
      assert_response :ok
      assert_equal last_check, @repository.checks.last
    end

    test 'not implemented event' do
      last_check = @repository.checks.last
      post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'pull_request' }
      assert_response :not_implemented
      assert_equal last_check, @repository.checks.last
    end
  end
end
