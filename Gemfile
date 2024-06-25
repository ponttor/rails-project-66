source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.8", ">= 7.0.8.3"

gem "stackprof"
gem "sentry-ruby"
gem "sentry-rails"
gem "pg"
gem 'slim_lint'

gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "dotenv"
  gem "sqlite3", "~> 1.4"
  gem 'byebug'
  gem 'faker'
end

group :development do
  gem "web-console"
  gem 'rubocop', '~> 1.64', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"

end
