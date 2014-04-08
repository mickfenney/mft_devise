########################################################################################################################
# These rake tasks will only run in development mode
########################################################################################################################
namespace :prod do
  @heroku_bin       = `which heroku`.chomp
  @prod_db_name     = 'mft-devise-dev'
  @prod_db_user     = 'action'
  @prod_db_host     = 'localhost'
  @prod_latest_file = "#{Rails.root.to_s}/tmp/latest_heroku.dump"
######################################################################################################################## 
  desc "Load the production db (dump the production db and load it to the development db)"
  task 'db:2dev' => :environment do
    prod_db2dev
  end

  def prod_db2dev
    prod_exit_unless_dev
    prod_db_backup
    prod_db_pull
    prod_db_load
  end 
########################################################################################################################
  desc "Backup the prod db (backup the production database in heroku)"
  task 'db:backup' => :environment do
    prod_db_backup
  end
 
  def prod_db_backup
    prod_exit_unless_dev
    cmd = "ruby #{@heroku_bin} pgbackups:capture"
    begin
      system(cmd)
      puts "Backing up the production database in heroku"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
########################################################################################################################
  desc "Pull the prod db (pull the production database from heroku)"
  task 'db:pull' => :environment do
    prod_db_pull
  end
 
  def prod_db_pull
    prod_exit_unless_dev
    cmd = "curl -o #{@latest_file} `ruby #{@heroku_bin} pgbackups:url`"
    begin
      system(cmd)
      puts "Pull the production database from heroku to [#{@prod_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
######################################################################################################################## 
  desc "Load the prod db (load the production database into devlopment)"
  task 'db:load' => :environment do
    prod_db_load
  end

  def prod_db_load
    prod_exit_unless_dev
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h #{@prod_db_host} -U #{@prod_db_user} -d #{@prod_db_name} #{@prod_latest_file}"
    begin
      system(cmd)
      puts "Loaded the devlopment database from the [#{@prod_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end 
########################################################################################################################
  private
########################################################################################################################
  def prod_exit_unless_dev
    if Rails.env != 'development'
      puts '!! Will not dump or load the production db in anything other than development mode. Quitting.'
      exit
    end
  end
########################################################################################################################
end
