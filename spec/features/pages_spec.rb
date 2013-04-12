require 'spec_helper'

describe "Pages" do

  subject { page }

  describe "Contact page" do
    before { visit contact_path }
    
    it { should have_selector('h3', text: 'Contact Us') }
  end  

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h3', text: 'About Us') }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign In"
    page.should have_selector('h3', text: 'Sign In')    
    click_link "Sign Up"
    page.should have_selector('h3', text: 'Sign Up')   
    click_link "Contact"
    page.should have_selector('h3', text: 'Contact Us')       
    click_link "About"
    page.should have_selector('h3', text: 'About Us')
  end

end
