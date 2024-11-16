# frozen_string_literal: true

require 'test_helper'
require 'json'

class Linter::JavascriptLintServiceTest < ActiveSupport::TestCase
  test 'should parse ESLint results correctly' do
    eslint_json = File.read('test/fixtures/files/eslint_result.json')
    eslint_json = eslint_json.strip.gsub(/\s+/, ' ')
    check_results, number_of_violations = Linter::JavascriptLintService.parse_lint_results(eslint_json, '')

    assert_equal 3, check_results.size
    assert_equal 6, number_of_violations

    first_result = check_results.first

    assert_equal 1, first_result['messages'].size
    assert_equal 'Unexpected console statement.', first_result['messages'].first['message']
    assert_equal 'no-console', first_result['messages'].first['ruleId']
    assert_equal 33, first_result['messages'].first['line']
    assert_equal 5, first_result['messages'].first['column']
  end

  test 'should return empty results for files without violations' do
    eslint_json_no_violations = File.read('test/fixtures/files/eslint_result_no_offences.json')

    check_results, number_of_violations = Linter::JavascriptLintService.parse_lint_results(eslint_json_no_violations, '')

    assert_empty check_results
    assert_equal 0, number_of_violations
  end
end
