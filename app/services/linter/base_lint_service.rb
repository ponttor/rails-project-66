# frozen_string_literal: true

module Linter
  class BaseLintService
    def initialize(path)
      @path = path
    end

    def perform_lint(command)
      stdout, = run_programm(command)
      stdout
    end

    def parse_lint_results(json_string)
      lint_data = JSON.parse(json_string)
      files_results = lint_data['files'] || lint_data

      offenses_count = 0
      check_results = []

      files_results
        .filter { |file_result| file_result['offenses'].present? || file_result['messages'].present? }
        .each do |file_result|
          src_file, file_offenses_count = process_file_result(file_result)
          check_results << src_file
          offenses_count += file_offenses_count
        end

      [check_results, offenses_count]
    end

    private

    def run_programm(command)
      stdout, exit_status = Open3.popen3(command) do |_, stdout, _, wait_thr|
        [stdout.read, wait_thr.value]
      end
      [stdout, exit_status.exitstatus]
    end

    def process_file_result(file_result)
      src_file = { 'filePath' => extract_relative_path(file_result['path'] || file_result['filePath'], @path),
                   'messages' => [] }
      offenses_count = 0

      (file_result['offenses'] || file_result['messages']).each do |offense|
        src_file['messages'] << format_offense(offense)
        offenses_count += 1
      end

      [src_file, offenses_count]
    end

    def extract_relative_path(full_path, base_path)
      relative_path = full_path.partition(base_path).last
      relative_path.empty? || relative_path == full_path ? full_path : relative_path
      # full_path.partition(base_path).last
    end

    def format_offense(offense)
      {
        'message' => offense['message'],
        'ruleId' => offense['cop_name'] || offense['ruleId'],
        'line' => offense['location']&.[]('line') || offense['line'],
        'column' => offense['location']&.[]('column') || offense['column']
      }
    end
  end
end
