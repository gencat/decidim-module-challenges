# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.29-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-challenges", path: "."

gem "bootsnap"
gem "puma", ">= 4.3"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", ">= 11.1.3"
  gem "decidim-dev", DECIDIM_VERSION
  gem "rubocop"
  gem "rubocop-rails"
  gem "rspec-rails", "~> 6.0.4"
  gem "rubocop-factory_bot", "~> 2.26"
end

group :development do
  gem "faker"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", ">= 4.4.0"
  gem "spring-watcher-listen"
  gem "web-console", "~> 3.5"
end
