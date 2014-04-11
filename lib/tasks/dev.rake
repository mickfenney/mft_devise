########################################################################################################################
# These rake tasks will only run in development mode
########################################################################################################################
$LOAD_PATH << File.dirname(__FILE__)
require 'application_environment_utility'
########################################################################################################################
namespace :dev do
  @aeu = ApplicationEnvironmentUtility.new
########################################################################################################################  
  desc "Rebuild the application (drop and recreate dev/test databases)"
  task :rebuild => :environment do
    @aeu.app_rebuild
  end
########################################################################################################################
  desc "Rebuild the test environment (drop and prepare test database, remove mock web cassettes)"
  task 'rebuild:test' => :environment do
    @aeu.test_rebuild
  end
########################################################################################################################
  desc "Backup the dev db (backup the development database locally)"
  task 'db:backup' => :environment do
    @aeu.dev_db_backup
  end
######################################################################################################################## 
  desc "Load the dev db (re-load dev database from the latest dev file)"
  task 'db:load' => :environment do
    @aeu.dev_db_load
  end
########################################################################################################################
end
