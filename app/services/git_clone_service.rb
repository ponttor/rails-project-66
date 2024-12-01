# frozen_string_literal: true

class GitCloneService
  class GitFetchError < StandardError; end

  GITHUB_API_BASE_URL = 'https://api.github.com/repos/'

  def initialize(repository, path)
    @repository = repository
    @path = path
  end

  def fetch_repository
    FileUtils.rm_rf(@path)
    output, exit_status = run_programm "git clone #{@repository.clone_url} #{@path}"

    raise GitFetchError, "Failed to clone repository: #{output}" unless exit_status.zero?

    fetch_last_commit_id
  end

  private

  def run_programm(command)
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end

  def fetch_last_commit_id
    commit_id_command = "cd #{@path} && git rev-parse --short HEAD"
    stdout, exit_status = run_command(commit_id_command)

    raise GitFetchError, "Failed to fetch last commit ID: #{stdout}" unless exit_status.zero?

    stdout.strip
  end
end
