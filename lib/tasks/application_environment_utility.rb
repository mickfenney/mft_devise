require 'fileutils'

class ApplicationEnvironmentUtility

  def initialize
    if Rails.env == 'development'
      @db_name          = 'mft-devise-dev'
      @dev_latest_file  = "#{Rails.root.to_s}/tmp/latest_dev.dump"
      @prod_latest_file = "#{Rails.root.to_s}/tmp/latest_heroku.dump"
      @verbose          = '--verbose'
    end
    if Rails.env == 'test'
      @db_name          = 'mft-devise-testrake'
      @dev_latest_file  = "#{Rails.root.to_s}/tmp/latest_test.dump"
      @prod_latest_file = "#{Rails.root.to_s}/tmp/latest_heroku_test.dump"
      @verbose          = ''
    end    
    @db_user    = 'action'
    @db_host    = 'localhost'
    @heroku_bin = `which heroku`.chomp
  end 
########################################################################################################################
# Development Tasks
########################################################################################################################  
  def app_rebuild
    exit_if_production
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['log', 'tmp', 'public/uploads', 'public/assets']
  end  
########################################################################################################################  
  def test_rebuild
    exit_if_production
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['spec/vcr_cassettes']
  end  
########################################################################################################################   
  def dev_db_backup
    exit_if_production
    cmd = "pg_dump -Fc --no-acl --no-owner -h #{@db_host} -U #{@db_user} #{@db_name} > #{@dev_latest_file}"
    begin
      puts "Backing up the development database [#{@db_name}] to [#{@dev_latest_file}]"
      system(cmd)
    rescue
      fail "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end 
########################################################################################################################  
  def dev_db_load
    exit_if_production
    raise "PG dump file does not exist: #{@dev_latest_file}, do you need to 'rake dev:db:backup ' first?" unless File.exist?(@dev_latest_file)
    cmd = "pg_restore #{@verbose} --clean --no-acl --no-owner -h #{@db_host} -U #{@db_user} -d #{@db_name} #{@dev_latest_file}"
    begin
      system(cmd)
      puts "Loaded the devlopment database from [#{@dev_latest_file}]"
    rescue
      fail "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end      
########################################################################################################################
# Production to Deveoepment Database Load
######################################################################################################################## 
  def prod_db2dev
    exit_if_production
    prod_db_backup
    prod_db_pull
    prod_db_load
  end 
########################################################################################################################  
  def prod_db_backup
    exit_if_production
    cmd = "ruby #{@heroku_bin} pgbackups:capture --app mft-asoftware"
    begin
      puts "Backing up the production database on heroku"
      system(cmd)
    rescue
      fail "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
########################################################################################################################    
  def prod_db_pull
    exit_if_production
    cmd = "curl -o #{@prod_latest_file} `ruby #{@heroku_bin} pgbackups:url --app mft-asoftware`"
    begin
      system(cmd)
      puts "Pulled the production database from heroku to [#{@prod_latest_file}]"
    rescue
      fail "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end   
########################################################################################################################  
  def prod_db_load
    exit_if_production
    raise "PG dump file does not exist: #{@prod_latest_file}, do you need to 'rake prod:db:pull ' first?" unless File.exist?(@prod_latest_file)
    cmd = "pg_restore #{@verbose} --clean --no-acl --no-owner -h #{@db_host} -U #{@db_user} -d #{@db_name} #{@prod_latest_file}"
    begin
      system(cmd)
      puts "Loaded the devlopment database from the [#{@prod_latest_file}]"
    rescue
      fail "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end 
########################################################################################################################
  private
########################################################################################################################
  def exit_if_production
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
