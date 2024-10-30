# frozen_string_literal: true

class RubyLintService
  def initialize(path)
    @path = path
  end

  def perform_ruby_lint
    stdout, = run_programm("bundle exec rubocop #{@path} --format=json --config ./.rubocop.yml")
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
        src_file, file_offenses_count = process_file_result(file_result, path)
        check_results << src_file
        offenses_count += file_offenses_count
      end

    [check_results, offenses_count]
  end

  private

  def self.process_file_result(file_result, path)
    src_file = { 'filePath' => extract_relative_path(file_result['path'], path), 'messages' => [] }
    offenses_count = 0

    file_result['offenses'].each do |offense|
      src_file['messages'] << format_offense(offense)
      offenses_count += 1
    end

    [src_file, offenses_count]
  end

  def self.extract_relative_path(full_path, base_path)
    full_path.partition(base_path).last
  end

  def self.format_offense(offense)
    {
      'message' => offense['message'],
      'ruleId' => offense['cop_name'],
      'line' => offense['location']['line'],
      'column' => offense['location']['column']
    }
  end

  def run_programm(command)
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end
end
