# frozen_string_literal: true

COMMIT_ID = '0078700'

class Stub
  def initialize(repository, path)
    @repository = repository
    @path = path
  end

  def fetch_repository
    COMMIT_ID
  end
end
