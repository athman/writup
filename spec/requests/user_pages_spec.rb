require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "Sign up page" do
    
    before { visit signup_path }
    let(:submit) { "Sign up" }
    
    it { should have_title(full_title("Sign up")) }
    it { should have_selector("h2", :text => "Sign up") }
    
    describe "with invalid information" do
      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
    end
    
    describe "with valid information" do
      
      before do
        fill_in "user_first_name",               with: "Alice"
        fill_in "user_surname",                  with: "Magnolia"
        fill_in "user_email",                    with: "alice@wonderland.com"
        fill_in "user_password",                 with: "secretword"
        fill_in "user_password_confirmation",    with: "secretword"
      end
      
      it "should create a new user" do
        expect{  click_button submit }.to change(User, :count).by(1)
      end
      
    end
    
  end
  
  describe "profile page" do
    let(:user) { create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.first_name) }
    it { should have_title(full_title(user.first_name)) }
    
  end
  
end
