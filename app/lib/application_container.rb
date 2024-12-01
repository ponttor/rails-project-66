# frozen_string_literal: true

require 'rails'
require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { Stub::OctokitClient }
    register :fetch_repository, -> { Stub::GitCloneService }
  else
    register :octokit_client, -> { Octokit::Client }
    register :fetch_repository, -> { GitCloneService }
  end
end
