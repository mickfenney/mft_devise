require 'spec_helper'

describe "Pages" do

  subject { page }

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h3', text: 'About Us') }

    #it { should have_selector('title', text: full_title('About Us')) }
  end

  # describe "Contact page" do
  #   before { visit contact_path }
    
  #   it { should have_selector('h1', text: 'Contact') }
  #   it { should have_selector('title', text: full_title('Contact')) }
  # end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign In"
    page.should have_selector('h3', text: 'Sign In')    
    click_link "Sign Up"
    page.should have_selector('h3', text: 'Sign Up')      
    click_link "About"
    page.should have_selector('h3', text: 'About Us')
  end

end
