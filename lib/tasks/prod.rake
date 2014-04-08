########################################################################################################################
namespace :prod do
  @latest_file = "#{Rails.root.to_s}/tmp/latest_heroku.dump"
  @heroku_bin = `which heroku`.chomp
######################################################################################################################## 
  desc "Load the production db (dump the production db and load it to the development db)"
  task 'db:2dev' => :environment do
    prod_db2dev
  end

  def prod_db2dev
    dev_only
    db_backup
    db_pull
    db_load
  end 
########################################################################################################################
  desc "Backup the prod db (backup the production database in heroku)"
  task 'db:backup' => :environment do
    db_backup
  end
 
  def db_backup
    dev_only
    cmd = "ruby #{@heroku_bin} pgbackups:capture"
    begin
      system(cmd)
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
########################################################################################################################
  desc "Pull the prod db (pull the production database from heroku)"
  task 'db:pull' => :environment do
    db_pull
  end
 
  def db_pull
    dev_only
    cmd = "curl -o #{@latest_file} `ruby #{@heroku_bin} pgbackups:url`"
    begin
      system(cmd)
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
######################################################################################################################## 
  desc "Load the prod db (load the production database into devlopment)"
  task 'db:load' => :environment do
    db_load
  end

  def db_load
    dev_only
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U action -d mft-devise-dev #{@latest_file}"
    begin
      system(cmd)
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end 
########################################################################################################################
  private
########################################################################################################################
  def dev_only
    if Rails.env != 'development'
      puts '!! Will not dump the production db in anything other than development mode. Quitting.'
      exit
    end
  end
########################################################################################################################
end
