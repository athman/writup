require 'spec_helper'
  
describe "Pages" do

  subject { page }
  
  describe "Home page" do
    
    before { visit root_path }
    
    it { should have_content("Writup") }
    it { should have_title(full_title("")) }
    it { should_not have_title("home") }
    it { should have_content("Welcome to Writup") }
    it { should have_selector("a", :text => "Sign in") }
    it { should have_selector("a", :text => "Sign up") }
    
  end
  
  describe "Help page" do
    
    before { visit help_path }
    
    it { should have_content("Help") }
    it { should have_title("Writup::Help") }
 
  end
  
  describe "About page" do
    
    before { visit about_path }
    
    
    it { should have_content("About") }
    it { should have_title("Writup::About") }
    
  end
  
  describe "Contact page" do
    
    before { visit help_path }
    
    it { should have_content("Help") }
    it { should have_title("Writup::Help") }
    
  end

end
