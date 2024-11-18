# frozen_string_literal: true

require 'test_helper'

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repository = repositories(:ruby)
      @github_id = @repository.github_id
    end

    test 'push-event' do
      # assert_not Repository.exists?(id: 777)
      post api_checks_url, params: { repository: { id: 777 } }, headers: { 'X-GitHub-Event': 'push' }
      assert_response :not_found
      assert_not Repository::Check.exists?(repository_id: 777)

      post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'push' }
      assert_response :ok
      last_check = @repository.checks.last
      ruby_bad_check = repository_checks(:ruby_good_check)

      assert last_check.passed == ruby_bad_check.passed
      assert last_check.offenses_count == ruby_bad_check.offenses_count
      assert last_check.check_results == ruby_bad_check.check_results
    end

    test 'ping-event' do
      last_check = @repository.checks.last
      post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'ping' }
      assert_response :ok
      assert last_check == @repository.checks.last
    end

    test 'not implemented event' do
      last_check = @repository.checks.last
      post api_checks_url, params: { repository: { id: @github_id } }, headers: { 'X-GitHub-Event': 'pull_request' }
      assert_response :not_implemented
      assert last_check == @repository.checks.last
    end
  end
end
