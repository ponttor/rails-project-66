# frozen_string_literal: true

require 'test_helper'

class LintCheckJobTest < ActiveJob::TestCase
  setup do
    @repository = repositories(:ruby)
    @check = repository_checks(:ruby_created)
  end

  test 'should perform lint check successfully' do
    assert_enqueued_with(job: LintCheckJob) do
      LintCheckJob.perform_later(@check.id, @repository.id)
    end

    LintCheckJob.perform_now(@check.id, @repository.id)

    @check.reload
    assert_equal 'finished', @check.state
    assert @check.passed?
  end
end
