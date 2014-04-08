########################################################################################################################
# These rake tasks will only run in development mode
########################################################################################################################
require 'fileutils'
########################################################################################################################
namespace :dev do
  @dev_db_name     = 'mft-devise-dev'
  @dev_db_user     = 'action'
  @dev_db_host     = 'localhost'
  @dev_latest_file = "#{Rails.root.to_s}/tmp/latest_dev.dump"
########################################################################################################################  
  desc "Rebuild the application (drop and recreate dev/test databases)"
  task :rebuild => :environment do
    app_rebuild
  end

  def app_rebuild
    dev_exit_unless_dev
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['log', 'tmp', 'public/uploads', 'public/assets']
  end
########################################################################################################################
  desc "Rebuild the test environment (drop and prepare test database, remove mock web cassettes)"
  task 'rebuild:test' => :environment do
    test_rebuild
  end

  def test_rebuild
    dev_exit_unless_dev
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['spec/vcr_cassettes']
  end
########################################################################################################################
  desc "Backup the dev db (backup the development database locally)"
  task 'db:backup' => :environment do
    dev_db_backup
  end
 
  def dev_db_backup
    dev_exit_unless_dev
    cmd = "pg_dump -Fc --no-acl --no-owner -h #{@dev_db_host} -U #{@dev_db_user} #{@dev_db_name} > #{@dev_latest_file}"
    begin
      system(cmd)
      puts "Backing up the development database [#{@dev_db_name}] to [#{@dev_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end
  end
######################################################################################################################## 
  desc "Load the dev db (re-load dev database from the latest dev file)"
  task 'db:load' => :environment do
    dev_db_load
  end

  def dev_db_load
    dev_exit_unless_dev
    cmd = "pg_restore --verbose --clean --no-acl --no-owner -h #{@dev_db_host} -U #{@dev_db_user} -d #{@dev_db_name} #{@dev_latest_file}"
    begin
      system(cmd)
      puts "Loaded the devlopment database from [#{@dev_latest_file}]"
    rescue
      puts "Failed to execute system command: #{cmd}\nCause: #{$!.message}"
    end   
  end 
########################################################################################################################
  private
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
  def dev_exit_unless_dev
    if Rails.env != 'development'
      puts '!! Will not dump or rebuild the development db in anything other than development mode. Quitting.'
      exit
    end
  end
########################################################################################################################
end