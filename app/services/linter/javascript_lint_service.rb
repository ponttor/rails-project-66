# frozen_string_literal: true

class Linter::JavascriptLintService
  def self.perform_lint(path)
    run_programm "find #{path} -name '*eslint*.*' -type f -delete"
    stdout, = run_programm "yarn run eslint --config app/services/linter/configs/.eslintrc.yml --format json --no-eslintrc #{path}"
    stdout.split("\n")[2]
  end

  def self.parse_lint_results(json_string, temp_repo_path)
    results = JSON.parse(json_string)

    number_of_offenses = 0
    check_results = []

    results
      .filter { |file_result| !file_result['messages'].empty? }
      .each do |file_result|
      src_file = {}
      src_file['filePath'] = file_result['filePath'].partition(temp_repo_path).last
      src_file['messages'] = []
      file_result['messages'].each do |message|
        offense = {}
        offense['message'] = message['message']
        offense['ruleId'] = message['ruleId']
        offense['line'] = message['line']
        offense['column'] = message['column']
        src_file['messages'] << offense
        number_of_offenses += 1
      end
      check_results << src_file
    end
    [check_results, number_of_offenses]
  end

  def self.run_programm(command)
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    # pp exit_status.exitstatus # https://docs.ruby-lang.org/en/2.0.0/Process/Status.html#method-i-exitstatus
    [stdout, exit_status.exitstatus]
  end
end
