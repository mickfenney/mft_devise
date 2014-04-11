########################################################################################################################
# These rake tasks will only run in development mode
########################################################################################################################
$LOAD_PATH << File.dirname(__FILE__)
require 'application_environment_utility'
########################################################################################################################
namespace :prod do
  @aeu = ApplicationEnvironmentUtility.new
######################################################################################################################## 
  desc "Load the production db (dump the production db and load it to the development db)"
  task 'db:2dev' => :environment do
    @aeu.prod_db2dev
  end
########################################################################################################################
  desc "Backup the prod db (backup the production database in heroku)"
  task 'db:backup' => :environment do
    @aeu.prod_db_backup
  end
########################################################################################################################
  desc "Pull the prod db (pull the production database from heroku)"
  task 'db:pull' => :environment do
    @aeu.prod_db_pull
  end
######################################################################################################################## 
  desc "Load the prod db (load the production database into devlopment)"
  task 'db:load' => :environment do
    @aeu.prod_db_load
  end
########################################################################################################################  
end
