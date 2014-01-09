require 'spec_helper'

describe "Pages" do

  describe "Home page" do
    
    it "should have the content 'Writup'" do
      visit '/pages/home'
      expect(page).to have_content("Writup")
    end
    
    it "should have the right title" do
      visit '/pages/home'
      expect(page).to have_title("Writup::Home")
    end
    
  end
  
  describe "Help page" do
    
    it "should have the content 'Help'" do
      visit '/pages/help'
      expect(page).to have_content("Help")
    end
    
    it "should have the right title" do
      visit '/pages/help'
      expect(page).to have_title("Writup::Help")
    end
    
  end
  
  describe "About page" do
    
    it "should have the content 'About'" do
      visit '/pages/about'
      expect(page).to have_content("About")
    end
    
    it "should have the right title" do
      visit '/pages/about'
      expect(page).to have_title("Writup::About")
    end
    
  end
  
  describe "Contact page" do
    
    it "should have the content 'Help'" do
      visit '/pages/help'
      expect(page).to have_content("Help")
    end
    
    it "should have the right title" do
      visit '/pages/contact'
      expect(page).to have_title("Writup::Contact")
    end
    
  end

end
