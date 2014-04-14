require 'spec_helper'

describe ApplicationEnvironmentUtility, :slow do

	before(:all) do
    system('rake db:create RAILS_ENV=testrake')
    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "127.0.0.1",
      :username => "action",
      :database => "mft-devise-testrake"
    )
    @aeu = ApplicationEnvironmentUtility.new
    @dev_latest_file  = "#{Rails.root.to_s}/tmp/latest_test.dump"
    @prod_latest_file = "#{Rails.root.to_s}/tmp/latest_heroku_test.dump"
	end
  
  after(:all) do
    if File.exist?(@dev_latest_file)
      FileUtils.remove_file(@dev_latest_file, :force => true)
    end
    if File.exist?(@prod_latest_file)
      FileUtils.remove_file(@prod_latest_file, :force => true)
    end
    ActiveRecord::Base.establish_connection(
      :adapter  => "postgresql",
      :host     => "127.0.0.1",
      :username => "action",
      :database => "mft-devise-test"
    )
  end  
  
################################################################################
  describe "Class Instantiation without Constructor Parameter:" do
    describe "#new" do
      it "no parameters and returns a ProdDev object" do
        @aeu.should be_an_instance_of ApplicationEnvironmentUtility
      end
    end  
  end
################################################################################  	
# Development
################################################################################
  describe "Development Rake Tasks" do

    it "should backup development database" do
      FileUtils.remove_file(@dev_latest_file, :force => true)
      File.exist?(@dev_latest_file).should be_false
      @aeu.dev_db_backup
      File.exist?(@dev_latest_file).should be_true
    end

    it "should not raise an exception when the latest dev database is loaded from backup" do
      @aeu.dev_db_backup
      @aeu.dev_db_load
    end

    it "should raise an exception when the latest dev database backup file is not present" do
      FileUtils.remove_file(@dev_latest_file, :force => true)
      expect {
        @aeu.dev_db_load
      }.to raise_error
    end
    
  end
################################################################################  	
# Production
################################################################################  
  describe "Production Rake Tasks" do

    it "should backup the production database on heroku (spec only runs once per day)" do
      pending "need to get a list of backups from heroku toolbelt??"
    end
    
    it "should pull down the latest production backup from heroku" do
      FileUtils.remove_file(@prod_latest_file, :force => true)
      File.exist?(@prod_latest_file).should be_false
      @aeu.prod_db_pull
      File.exist?(@prod_latest_file).should be_true
    end

    it "should not raise an exception when the latest prod database is loaded from backup" do
      @aeu.prod_db_pull
      @aeu.prod_db_load
    end
    
    it "should raise an exception when the latest production database backup file is not present" do
      FileUtils.remove_file(@prod_latest_file, :force => true)
      expect {
        @aeu.prod_db_load
      }.to raise_error
    end    
    
  end    
################################################################################
end
