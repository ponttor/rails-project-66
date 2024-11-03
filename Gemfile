# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 7.0.8', '>= 7.0.8.3'

gem 'aasm'
gem 'fileutils'
gem 'httparty'
gem 'i18n'
gem 'octokit'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'open3'
gem 'pg'
gem 'pundit'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'simple_form'
gem 'slim_lint'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'stackprof'

gem 'dry-auto_inject', '~> 1.0', '>= 1.0.1'
gem 'dry-container', '~> 0.11.0'

gem 'rubocop-performance', require: false
gem 'rubocop-rails', require: false

gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.0'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv'
  gem 'faker'
  gem 'simplecov'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'rubocop', '~> 1.64', require: false

  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webmock'
end
