########################################################################################################################
# These rake tasks will only run in development mode
########################################################################################################################
$LOAD_PATH << File.dirname(__FILE__)
require 'prod_dev'
require 'fileutils'
########################################################################################################################
namespace :dev do
  @pd = ProdDev.new
########################################################################################################################  
  desc "Rebuild the application (drop and recreate dev/test databases)"
  task :rebuild => :environment do
    @pd.app_rebuild
  end
########################################################################################################################
  desc "Rebuild the test environment (drop and prepare test database, remove mock web cassettes)"
  task 'rebuild:test' => :environment do
    @pd.test_rebuild
  end
########################################################################################################################
  desc "Backup the dev db (backup the development database locally)"
  task 'db:backup' => :environment do
    @pd.dev_db_backup
  end
######################################################################################################################## 
  desc "Load the dev db (re-load dev database from the latest dev file)"
  task 'db:load' => :environment do
    @pd.dev_db_load
  end
########################################################################################################################
end