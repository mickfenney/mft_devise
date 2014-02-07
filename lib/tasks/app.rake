require 'fileutils'

namespace :app do
  desc "Rebuild the application (drop and recreate dev/test databases)"
  task :rebuild => :environment do
    app_rebuild
  end

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

    dirs = ['log', 'tmp', 'public/uploads', 'public/assets']
    dirs.each do |d|
      if Dir.exist?(d)
        puts "+ Cleaning directory [#{d}]"
        FileUtils.rm_rf(d)
        FileUtils.mkdir_p(d)
      end
    end
  end

end