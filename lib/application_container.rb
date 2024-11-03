# frozen_string_literal: true

require 'rails'
require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    require './lib/stub'
    require './lib/stub/octokit_client'
    register :octokit_client, -> { Stub::OctokitClient }
    register :fetch_repository, -> { Stub }
  else
    register :octokit_client, -> { Octokit::Client }
    register :fetch_repository, -> { GitCloneService }
  end
end
