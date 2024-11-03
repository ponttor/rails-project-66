# frozen_string_literal: true

require 'test_helper'

class LintServiceTest < ActiveSupport::TestCase
  setup do
    @repository = repositories(:ruby)
    @check = repository_checks(:created)
    @lint_service = LintService.new(@check, @repository)
  end

  test 'should perform check successfully' do
    @lint_service.perform_check

    assert_equal 'finished', @check.state
    assert @check.passed?
  end

  test 'should raise error for unsupported language' do
    @repository.language = 'unsupported_language'

    assert_raises(LintService::UnsupportedLanguageError, 'Unsupported language: unsupported_language') do
      @lint_service.send(:choose_lint_service)
    end
  end
end
