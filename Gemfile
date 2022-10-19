# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.0.2"

gem "bootsnap", require: false
gem "devise"
gem "devise-jwt"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "pundit", "~> 2.2"
gem "rack-cors"
gem "rails", "~> 7.0.2", ">= 7.0.2.4"
gem "ransack"
gem "rswag-api"
gem "rswag-ui"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-rails"
  gem "rspec-rails"
  gem "rswag"
  gem "rubocop-rspec", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false
end

group :development do
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end
