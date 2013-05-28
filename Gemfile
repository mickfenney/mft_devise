source 'https://rubygems.org'
unless RUBY_PLATFORM =~ /mingw/i
  ruby "2.0.0"
  #gem 'therubyracer'
  gem 'libnotify'  
end
gem 'rails', '3.2.13'
gem 'jquery-rails'
gem "thin", ">= 1.5.1"
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "devise_invitable", ">= 1.1.5"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
group :development do
  #gem 'sqlite3'
  gem 'mysql2'
  gem "better_errors", ">= 0.6.0" unless `hostname`.strip.downcase.match(/^rav/)
  gem 'guard-spork'
  gem 'guard'
  gem 'guard-rspec'
  gem 'growl'
  gem 'ruby_gntp'
  gem 'wdm', :require => false unless RUBY_PLATFORM =~ /darwin/i
  gem "letter_opener", ">= 1.1.0"
  gem "quiet_assets", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  gem "rspec-rails", ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.2.0"
end
group :test do
  #gem 'sqlite3'
  gem 'mysql2'
  gem 'rspec'
  gem 'growl'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'wdm', :require => false unless RUBY_PLATFORM =~ /darwin/i
  gem "capybara", ">= 2.0.2"
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem "rspec-rails", ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.2.0"
end
group :production do
  #gem 'pg'
  gem 'mysql2'
end
gem 'will_paginate', '> 3.0'
gem "strip_attributes", ">= 1.2"
gem 'geocoder'
gem 'enumerated_attribute'
gem 'rack-mini-profiler'
gem 'active_attr'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'devise-async'
