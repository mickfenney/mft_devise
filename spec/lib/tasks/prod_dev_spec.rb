require 'spec_helper'

$LOAD_PATH << "#{Rails.root.to_s}/lib/tasks"
require 'prod_dev'

describe ProdDev do

	before(:each) do
	  @pd = ProdDev.new
	end

################################################################################
  describe "Class Instantiation without Constructor Parameter:" do
    describe "#new" do
        it "no parameters and returns a ProdDev object" do
            @pd.should be_an_instance_of ProdDev
        end
    end  
  end
################################################################################  	
# Development
################################################################################
  describe "Development Rake Tasks" do

    it "should backup development database" do
    	#@pd.dev_db_backup
    end

  end
end