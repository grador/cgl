source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.0.1'
gem 'rails', '4.1.6'

# Use mysql as the database for Active Record
gem 'mysql2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'

gem 'yaml_db', github: 'jetthoughts/yaml_db', ref: 'fb4b6bd7e12de3cffa93e0a298a1e5253d7e92ba'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'sass'
gem 'haml-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# gem 'compass'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
gem 'rails-dev-tweaks'
gem 'sprockets-rails', :require => 'sprockets/railtie'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
group :production do
  gem 'therubyracer', platforms: :ruby
end
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
group :development, :test do
	gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'timecop'
end
# Deploy with Capistrano
group :development do
  gem 'capistrano'
  gem 'rvm-capistrano' # нужен для корректной работы с rvm
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', :require => 'bcrypt'

# gem 'acts_as_xlsx'
gem 'axlsx'

gem 'exception_notification'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
