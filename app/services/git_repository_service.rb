# frozen_string_literal: true

class GitRepositoryService
  class GitFetchError < StandardError; end

  def initialize(repository, path)
    @repository = repository
    @path = path
  end

  def fetch_repository
    FileUtils.rm_rf(@path)
    _, exit_status = run_programm "git clone #{@repository.clone_url} #{@path}"

    raise 'Failed to clone repository' unless exit_status.zero?

    fetch_last_commit_id
  rescue GitFetchError => e
    raise "Failed to clone repository: #{e.message}"
  end

  private

  def run_programm(command)
    stdout, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end
    [stdout, exit_status.exitstatus]
  end

  def fetch_last_commit_id
    last_commit = HTTParty.get("https://api.github.com/repos/#{@repository.full_name}/commits").first
    last_commit['sha'].slice(0, 7)
  end
end
