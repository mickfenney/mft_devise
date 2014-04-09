require 'fileutils'

class ProdDev

  def initialize
    @db_name          = 'mft-devise-dev'
    @db_user          = 'action'
    @db_host          = 'localhost'
    @heroku_bin       = `which heroku`.chomp
    @dev_latest_file  = "#{Rails.root.to_s}/tmp/latest_dev.dump"
    @prod_latest_file = "#{Rails.root.to_s}/tmp/latest_heroku.dump"
  end 
########################################################################################################################
# Development Tasks
########################################################################################################################  
  def app_rebuild
    exit_unless_dev
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['log', 'tmp', 'public/uploads', 'public/assets']
  end  
########################################################################################################################  
  def test_rebuild
    exit_unless_dev
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['spec/vcr_cassettes']
  end  
########################################################################################################################   
  def dev_db_backup
    exit_unless_dev
    cmd = "pg_dump -Fc --no-acl --no-owner -h #{@db_host} -U #{@db_user} #{@db_name} > #{@dev_latest_file}"
    begin
      system(cmd)
      puts "Backing up the development database [#{@db_name}] to [#{@dev_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end 
########################################################################################################################  
  def dev_db_load
    exit_unless_dev
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h #{@db_host} -U #{@db_user} -d #{@db_name} #{@dev_latest_file}"
    begin
      system(cmd)
      puts "Loaded the devlopment database from [#{@dev_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end      
########################################################################################################################
# Production to Deveoepment Database Load
######################################################################################################################## 
  def prod_db2dev
    exit_unless_dev
    prod_db_backup
    prod_db_pull
    prod_db_load
  end 
########################################################################################################################  
  def prod_db_backup
    exit_unless_dev
    cmd = "ruby #{@heroku_bin} pgbackups:capture"
    begin
      system(cmd)
      puts "Backing up the production database in heroku"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
########################################################################################################################    
  def prod_db_pull
    exit_unless_dev
    cmd = "curl -o #{@prod_latest_file} `ruby #{@heroku_bin} pgbackups:url`"
    begin
      system(cmd)
      puts "Pulled the production database from heroku to [#{@prod_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end   
########################################################################################################################  
  def prod_db_load
    exit_unless_dev
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h #{@db_host} -U #{@db_user} -d #{@db_name} #{@prod_latest_file}"
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
  def exit_unless_dev
    if Rails.env == 'production'
      puts '!! Will not run rake task in anything other than development mode. Quitting.'
      exit
    end
  end
########################################################################################################################
  def clean_dirs(dirs = [])
    dirs.each do |d|
      if Dir.exist?(d)
        puts "+ Cleaning directory [#{d}]"
        FileUtils.rm_rf(d)
        FileUtils.mkdir_p(d)
      end
    end
  end
######################################################################################################################## 
end
