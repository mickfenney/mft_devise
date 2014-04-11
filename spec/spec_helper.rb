require 'rubygems'
require 'cancan/matchers'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'fileutils'
$LOAD_PATH << "#{Rails.root.to_s}/lib/tasks"
require 'application_environment_utility'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration) # RAILS 4+ Only

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  config.order = "random"

  #
  # Custom configuration for tennis-sessions by Cam
  #
  config.include FactoryGirl::Syntax::Methods

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.filter_run_excluding :slow unless ENV['SLOW_SPECS']

  config.include ActionView::TestCase::Behavior, example_group: {file_path: %r{spec/presenters}}
  config.include Rails.application.routes.url_helpers

  config.include(MailerMacros)
  #config.include(RequestMacros)
  #config.include(ControllerMacros)

  config.before(:each) { GC.disable }
  config.after(:each) { GC.enable }


  config.before(:suite) do
    #load "#{Rails.root}/db/seeds_roles.rb"
  end

  require 'strip_attributes/matchers'
  RSpec.configure do |config|
    config.include StripAttributes::Matchers
  end

end