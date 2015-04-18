source 'https://rubygems.org'

ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

gem "highcharts-rails", "~> 3.0.0"

# Use SCSS for stylesheets
gem 'sass-rails', '>= 3.2'

# To get Bootsrap included
gem 'bootstrap-sass', '~> 3.3.3'

# The Chosen library for adding functionality to your select boxes
gem 'chosen-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Plugin for jQuery that gives you some advanced tables
gem 'jquery-datatables-rails', '~> 3.2.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'bcrypt-ruby', '3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'parse-ruby-client', '~> 0.2.0'

gem 'humanize', '1.1.0'

# Handle attachments & store them in S3
gem 'aws-sdk'
gem "paperclip", "~> 4.2"

gem 'will_paginate', '3.0.7'

gem 'figaro'

gem 'simple_form'

gem 'public_activity', git: 'https://github.com/pokonski/public_activity.git'

gem 'cancancan', '~> 1.10'
gem 'pg',             '0.17.1'

# Use HelloSign API for signing documents
gem 'hellosign-ruby-sdk', :git => "https://github.com/ltlai/hellosign-ruby-sdk.git",
  :branch => 'parsed-errors'


gem 'boxr'

group :production do
  gem 'rails_12factor', '0.0.2'
end

group :development do
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'
  gem 'rails-erd'
  gem 'seed_dump'
end