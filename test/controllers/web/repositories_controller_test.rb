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

      assert_equal(1, 1)
    end

    test 'show' do
      get repository_url(@repository)
      assert_response :success
    end

    test 'new' do
      # get new_repository_url
      # assert_response :success
    end

    # test 'create' do
    #   response_body = load_fixture('files/mocked_repository.json')
    #   mocked_json_response = JSON.parse(response_body)

    #   post repositories_path(repository: { github_id: mocked_json_response['id'] })

    #   perform_enqueued_jobs

    #   created_repository = Repository.find_by!(
    #     name: mocked_json_response['name'],
    #     language: mocked_json_response['language']
    #   )

    #   assert { created_repository }
    #   assert_redirected_to repository_url(created_repository)
    # end
  end
end
