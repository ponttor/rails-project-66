# frozen_string_literal: true

class Stub::OctokitClient
  GITHUB_REPOS_JSON_PATH = 'test/fixtures/files/stub_github_repos.json'
  def initialize(*args); end

  def repos
    github_repos = JSON.load_file File.open(GITHUB_REPOS_JSON_PATH)
    github_repos.each(&:deep_symbolize_keys!)
  end

  def repo(github_id)
    repos_from_file = repos

    repo = repos_from_file.find { |r| r[:id] == github_id }
    return repo if repo.present?

    size = repos_from_file.size
    i = (github_id % size)
    repo = repos_from_file[i]
    repo[:id] = github_id
    repo
  end
end
