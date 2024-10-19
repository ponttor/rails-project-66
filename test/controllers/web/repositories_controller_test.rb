# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repository = repositories(:one)
      @user = users(:one)
      sign_in(@user)
    end

    test 'index' do
      get repositories_url
      assert_response :success

      assert_select 'table tbody tr' do |rows|
        assert_equal repositories.count, rows.count
      end
    end

    test 'show repository details' do
      get repository_url(@repository)
      assert_response :success

      assert_select 'h1', text: @repository.full_name

      assert_select 'p' do |elements|
        assert_match @repository.full_name, elements[0].text.strip
        assert_match @repository.language, elements[1].text.strip
        assert_match @repository.created_at.strftime('%d %B %Y, %H:%M'), elements[2].text.strip
        assert_match @repository.updated_at.strftime('%d %B %Y, %H:%M'), elements[3].text.strip
      end

      assert_select 'hr'
    end

    test 'new' do
      response = File.new('test/fixtures/files/mocked_repositories.json')
      stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
        .to_return(body: response, status: 200, headers: { 'Content-Type' => 'application/json' })

      get new_repository_url
      assert_response :success
    end

    test 'create repository successfully' do
      response = File.read('test/fixtures/files/mocked_repository.json')
      stub_request(:post, 'https://api.github.com/repositories/482905026')
        .to_return(body: response, status: 200, headers: { 'Content-Type' => 'application/json' })

      stub_request(:get, 'https://api.github.com/repositories/482905026')
        .to_return(body: response, status: 200, headers: { 'Content-Type' => 'application/json' })

      post repositories_url, params: { repository: { github_id: 482_905_026 } }

      assert_redirected_to repositories_url
      follow_redirect!
      assert_response :success

      created_repository = Repository.find_by(github_id: 482_905_026)
      assert_not_nil created_repository

      assert_equal 'book_pages', created_repository.name
      assert_equal 'ponttor/book_pages', created_repository.full_name
      assert_equal 'ruby', created_repository.language
      assert_equal 'https://github.com/ponttor/book_pages.git', created_repository.clone_url
      assert_equal 'git@github.com:ponttor/book_pages.git', created_repository.ssh_url
    end
  end
end
