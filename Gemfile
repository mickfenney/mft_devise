source 'https://rubygems.org'
gem 'rails', '3.2.13'
gem 'sqlite3'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "thin", ">= 1.5.1"
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "capybara", ">= 2.0.2", :group => :test
gem "database_cleaner", ">= 0.9.1", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "devise_invitable", ">= 1.1.5"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "quiet_assets", ">= 1.0.1", :group => :development
gem "figaro", ">= 0.5.3"
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]
group :development do
  gem "better_errors", ">= 0.6.0" unless `hostname`.strip.downcase.match(/^rav/)
  gem 'guard-spork'
  gem 'guard'
  gem 'guard-rspec'
  gem 'growl'
  gem 'ruby_gntp'
  gem 'wdm', :require => false unless RUBY_PLATFORM =~ /darwin/i
end
gem "letter_opener", ">= 1.1.0",  :group => :development
gem 'will_paginate', '> 3.0'
group :test do
  gem 'rspec'
  gem 'growl'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'wdm', :require => false unless RUBY_PLATFORM =~ /darwin/i
end
gem "strip_attributes", ">= 1.2"
gem 'geocoder'
gem 'enumerated_attribute'
gem 'rack-mini-profiler'
gem 'active_attr'
