# frozen_string_literal: true

class RubyLintService
  def initialize(path)
    @path = path
  end

  def perform_ruby_lint
    # byebug
    stdout, = run_programm("bundle exec rubocop #{@path} --format=json --config ./.rubocop.yml")
    # stdout, _ = run_programm("bundle exec rubocop --format json #{@path}")
    stdout
  end

  def self.parse_lint_results(path, json_string)
    rubocop_data = JSON.parse(json_string)
    rubocop_files_results = rubocop_data['files']

    offenses_count = 0
    check_results = []

    rubocop_files_results
      .filter { |file_result| file_result['offenses'].present? }
      .each do |file_result|
        src_file = {}
        src_file['filePath'] = file_result['path'].partition(path).last
        src_file['messages'] = []

        file_result['offenses'].each do |offense|
          violation = {
            'message' => offense['message'],
            'ruleId' => offense['cop_name'],
            'line' => offense['location']['line'],
            'column' => offense['location']['column']
          }

          src_file['messages'] << violation
          offenses_count += 1
        end

        check_results << src_file
      end

    [check_results, offenses_count]
  end

  private

  def run_programm(command)
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end
end
