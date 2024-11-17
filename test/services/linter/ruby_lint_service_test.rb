# frozen_string_literal: true

require 'test_helper'
require 'json'

class Linter::RubyLintServiceTest < ActiveSupport::TestCase
  test 'should parse RuboCop lint results correctly' do
    rubocop_json = File.read('test/fixtures/files/rubocop_result.json')

    check_results, offenses_count = Linter::RubyLintService.parse_lint_results(rubocop_json, '')

    assert_equal 1, check_results.size
    assert_equal 1, offenses_count

    first_result = check_results.first

    assert_equal 1, first_result['messages'].size
    assert_equal 'Method has too many lines. [15/10]', first_result['messages'].first['message']
  end

  test 'should return empty results for files without offenses' do
    rubocop_json_no_offenses = File.read('test/fixtures/files/rubocop_result_no_offenses.json')

    check_results, offenses_count = Linter::RubyLintService.parse_lint_results(rubocop_json_no_offenses, '')

    assert_empty check_results
    assert_equal 0, offenses_count
  end
end
