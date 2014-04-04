########################################################################################################################
namespace :prod do
  if Rails.env != 'development'
    puts '!! Will not dump the production db in anything other than development mode. Quitting.'
    return
  end
  @latest_file = "#{Rails.root.to_s}/tmp/latest_heroku.dump"
########################################################################################################################  
  desc "Load the production db (dump the production db and load it to the development db)"
  task 'db:2dev' => :environment do
    prod_db2dev
  end

  def prod_db2dev
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
    cmd = 'heroku pgbackups:capture'
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
    cmd = "curl -o #{@latest_file} `heroku pgbackups:url`"
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
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U action -d mft-devise-dev #{@latest_file}"
    begin
      system(cmd)
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end    
  end  
########################################################################################################################  
end
