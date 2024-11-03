# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:ruby)
    @check = repository_checks(:created)
    @user = users(:one)
  end

  test 'should show check' do
    sign_in(@user)
    get repository_check_url(@repository, @check)
    assert_response :success
    assert_select 'h1', text: 'Check #842905530'
  end

  test 'should create check and perform lint' do
    sign_in(@user)
    LintService.new(@check, @repository).perform_check

    assert_difference('Repository::Check.count', 1) do
      post repository_checks_url(@repository)
    end

    assert_equal 'finished', @check.state
    assert @check.passed?

    assert_not_nil @check.check_results
    assert @check.offenses_count.is_a?(Integer)
  end
end
