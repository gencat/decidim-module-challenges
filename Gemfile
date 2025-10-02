# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.29-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-challenges", path: "."

gem "bootsnap"
gem "puma", ">= 4.3"
gem "wkhtmltopdf-binary"
gem "uglifier", "~> 4.2"

group :development, :test do
  gem "byebug", ">= 11.1.3"
  gem "decidim-dev", DECIDIM_VERSION
  gem "rubocop"
  gem "rubocop-rails"
end

group :development do
  gem "faker"
  gem "letter_opener_web"
  gem "listen"
  gem "web-console", "~> 3.7"
end
