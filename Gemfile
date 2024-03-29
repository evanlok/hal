source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
#gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'
gem 'puma-heroku'
gem 'rack-cors', :require => 'rack/cors'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bundler', '>= 1.8.4'
gem 'devise'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'figaro'
gem 'autoprefixer-rails'
gem 'simple_form'
gem 'paloma'
gem 'faraday'
gem 'faraday_middleware'
gem 'typhoeus'
gem 'honeybadger', '~> 2.0'
gem 'friendly_id', '~> 5.1.0'
gem 'newrelic_rpm'
gem 'lograge'
gem 'oj'
gem 'oj_mimic_json'
gem 'hashie'
gem 'paper_trail'
gem 'acts_as_list'
gem 'non-stupid-digest-assets'
gem 'color'
gem 'aws-sdk', '~> 2.3'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-fontawesome'
  gem 'rails-assets-normalize-scss'
  gem 'rails-assets-ace-builds'
  gem 'rails-assets-lodash'
  gem 'rails-assets-pnotify'
  gem 'rails-assets-Sortable'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  gem 'quiet_assets'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.0'
  gem 'awesome_print'
  gem 'rubocop', require: false
end

group :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webmock'
  gem 'climate_control'
end

group :production do
  gem 'rails_12factor'
end
