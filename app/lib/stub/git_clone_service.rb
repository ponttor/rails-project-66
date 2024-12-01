# frozen_string_literal: true

class Stub::GitCloneService
  COMMIT_ID = '0078700'

  def initialize(repository, path)
    @repository = repository
    @path = path
  end

  def fetch_repository
    COMMIT_ID
  end
end
