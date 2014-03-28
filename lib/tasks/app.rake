require 'fileutils'
########################################################################################################################
namespace :app do
  desc "Rebuild the application (drop and recreate dev/test databases)"
  task :rebuild => :environment do
    app_rebuild
  end
########################################################################################################################
  def app_rebuild

    if Rails.env != 'development'
      puts '!! Will not rebuild app in anything other than development mode. Quitting.'
      return
    end

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
    Rake::Task['db:test:prepare'].execute
    clean_dirs ['spec/vcr_cassettes']
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
end