# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:ruby)
    @check = repository_checks(:ruby_created)
    @user = users(:one)
    sign_in(@user)
  end

  test 'show' do
    get repository_check_url(@repository, @check)
    assert_response :success
  end

  test 'create check and perform lint' do
    post repository_checks_url(@repository)
    perform_enqueued_jobs

    created_check = Repository::Check.last
    created_check.reload

    assert_equal 'finished', created_check.aasm_state
    assert created_check.passed?

    assert_not_nil created_check.check_results
    assert created_check.offenses_count.is_a?(Integer)
  end
end
