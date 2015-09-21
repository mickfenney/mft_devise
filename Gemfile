source 'https://rubygems.org'

unless RUBY_PLATFORM =~ /mingw/i
  ruby "2.1.0"
  gem 'pg'
  gem 'unicorn'
  #gem 'therubyracer'
  gem "rmagick", require: false
else
  gem 'mysql2', '0.3.11'
  gem "thin", ">= 1.5.1"
end

gem 'rails', '3.2.17'
gem 'rack', '~> 1.4.5'

gem 'jquery-rails'
gem "bootstrap-sass", "2.3.2.2"
gem "bootstrap-switch-rails", "1.8.1"
gem "devise", "2.2.4"
gem "devise_invitable", ">= 1.1.5"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
gem 'will_paginate', '> 3.0'
gem "strip_attributes", ">= 1.2"
gem 'geocoder'
gem 'active_enum'
gem 'active_attr'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'devise-async'
gem 'mandrill-rails'
gem 'tinymce-rails'
gem "carrierwave"
gem 'lazybox', '0.2.6'
gem 'bourbon'
gem 'jquery-fileupload-rails'
gem 'rack-timeout'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem "workless", "~> 1.1.3"
  gem 'rails_12factor'
end

group :test, :development do
  #gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'wdm', :require => false unless RUBY_PLATFORM =~ /darwin/i
  gem 'ruby_gntp'
  gem 'faker'
end

group :development do
  gem "quiet_assets", ">= 1.0.1"
  gem "better_errors", ">= 0.6.0" unless `hostname`.strip.downcase.match(/^rav/)
  #gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  gem "letter_opener", ">= 1.1.0"
  #gem 'rack-mini-profiler'
end

group :test do
  #gem 'libnotify'
  gem 'rspec'
  gem "rspec-rails", ">= 2.12.2"
  gem "capybara", ">= 2.0.2"
  gem "email_spec", ">= 1.4.0"
  gem "factory_girl_rails", ">= 4.2.0"
  gem 'guard', '>=2.2.3'
  gem 'guard-rspec'
  gem 'growl'
  gem "database_cleaner", ">= 0.9.1"
  gem 'webmock'
  gem 'vcr'
end
