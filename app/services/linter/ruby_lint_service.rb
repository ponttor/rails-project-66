# frozen_string_literal: true

class Linter::RubyLintService
  def self.perform_lint(path)
    command = "bundle exec rubocop #{path} --format=json --config app/services/linter/configs/.rubocop.yml"
    stdout, = Open3.popen3(command) { |_, stdout, _, wait_thr| [stdout.read, wait_thr.value] }
    stdout
  end

  def self.parse_lint_results(json_string, path)
    data = JSON.parse(json_string)
    results = data['files']

    number_of_offences = 0
    check_results = []

    results
      .filter { |result| !result['offenses'].empty? }
      .each do |result|
      src_file = {}
      src_file['filePath'] = result['path'].partition(path).last
      src_file['messages'] = []
      result['offenses'].each do |file_offense|
        offense = {}
        offense['message'] = file_offense['message']
        offense['ruleId'] = file_offense['cop_name']
        offense['line'] = file_offense['location']['line']
        offense['column'] = file_offense['location']['column']
        src_file['messages'] << offense
        number_of_offences += 1
      end
      check_results << src_file
    end
    [check_results, number_of_offences]
  end
end
