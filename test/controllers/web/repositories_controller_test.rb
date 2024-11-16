# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @repository = repositories(:ruby)
      @user = users(:one)
      sign_in(@user)
    end

    test 'index' do
      get repositories_url
      assert_response :success

      assert_select 'table tbody tr' do |rows|
        assert_equal @user.repositories.count, rows.count
      end
    end

    test 'show repository details' do
      get repository_url(@repository)
      assert_response :success

      assert_select 'h1', text: @repository.full_name

      assert_select 'p' do |elements|
        assert_match @repository.full_name, elements[0].text.strip
        assert_match @repository.language, elements[1].text.strip
        assert_match I18n.l(@repository.created_at, format: '%d %B %Y %H:%M'), elements[2].text.strip
        assert_match I18n.l(@repository.updated_at, format: '%d %B %Y %H:%M'), elements[2].text.strip
      end

      assert_select 'hr'
    end

    test 'new' do
      get new_repository_url
      assert_response :success
    end

    test 'create repository successfully' do
      post repositories_url, params: { repository: { github_id: 482_905_026 } }

      assert_redirected_to repositories_url

      created_repository = Repository.find_by(github_id: 482_905_026)
      assert_not_nil created_repository

      assert_equal 'alpha_project', created_repository[:name]
      assert_equal 'user_alpha/alpha_project', created_repository[:full_name]
      assert_equal 'ruby', created_repository[:language]
      assert_equal 'https://github.com/user_alpha/alpha_project', created_repository[:clone_url]
      assert_equal 'git@github.com:ponttor/Bulletin-Board.git', created_repository[:ssh_url]
    end

    test 'create repository with failure' do
      post repositories_url, params: { repository: { github_id: '' } }

      assert_response :unprocessable_entity
      assert_template :new

      assert_not_nil assigns(:repositories)

      assert_equal I18n.t('flash.repositories.create_error'), flash[:danger]
    end
  end
end
