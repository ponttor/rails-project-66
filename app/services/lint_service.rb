# frozen_string_literal: true

class LintService
  def initialize(path, language)
    @path = path
    @language = language.downcase
  end

  def perform_lint
    case @language
    when 'ruby'
      RubyLintService.new(@path).perform_ruby_lint
    when 'javascript'
      EslintService.new(@path).perform_eslint
    else
      raise "Unsupported language: #{@language}"
    end
  end

  def parse_lint_results(json_string)
    case @language
    when 'ruby'
      RubyLintService.parse_lint_results(@path, json_string)
    when 'javascript'
      EslintService.parse_lint_results(@path, json_string)
    else
      raise "Unsupported language: #{@language}"
    end
  end
end
