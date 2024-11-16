# frozen_string_literal: true

require_relative '../../lib/application_container'
require 'test_helper'

class OctokitServiceTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'get_remote_repositories' do
    repositories = OctokitService.get_remote_repositories(@user)

    assert_instance_of Array, repositories
    assert repositories.all?(Hash), 'Expected all items to be hashes'

    first_repo = repositories.first
    assert_equal 'alpha_project', first_repo[:name]
    assert_equal 'ruby', first_repo[:language]
    assert_equal 'user_alpha/alpha_project', first_repo[:full_name]
    assert_equal 'git@github.com:ponttor/Bulletin-Board.git', first_repo[:ssh_url]
  end

  test 'get_repository_data' do
    github_id = 102

    repository_data = OctokitService.get_repository_data(@user, github_id)

    assert_instance_of Hash, repository_data

    assert_equal github_id, repository_data[:id]
    assert_equal 'beta_project', repository_data[:name]
    assert_equal 'Javascript', repository_data[:language]
    assert_equal 'user_beta/beta_project', repository_data[:full_name]
    assert_equal 'git@github.com:ponttor/Bulletin-Board.git', repository_data[:ssh_url]
  end
end
