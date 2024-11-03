# frozen_string_literal: true

module Linter
  class RubyLintService < BaseLintService
    def perform_lint
      super("bundle exec rubocop #{@path} --format=json --config app/services/linter/configs/.rubocop.yml")
    end
  end
end
