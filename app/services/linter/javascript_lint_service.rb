# frozen_string_literal: true

module Linter
  class JavascriptLintService < BaseLintService
    def perform_lint
      super("yarn run eslint --format json #{@path}")
    end
  end
end
