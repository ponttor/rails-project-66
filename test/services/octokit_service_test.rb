# frozen_string_literal: true

require_relative '../../lib/application_container'
require 'test_helper'

class OctokitServiceTest < ActiveSupport::TestCase
  def setup
    @current_user = Struct.new(:token).new('fake_token')
  end

  def test_get_remote_repositories
    repositories = OctokitService.get_remote_repositories(@current_user)

    assert_instance_of Array, repositories
    assert repositories.all?(Hash), 'Expected all items to be hashes'
  end

  def test_get_repository_data
    github_id = 1

    repository_data = OctokitService.get_repository_data(@current_user, github_id)

    assert_instance_of Hash, repository_data
    assert_equal github_id, repository_data[:id], "Expected repository ID to be #{github_id}"
  end
end
