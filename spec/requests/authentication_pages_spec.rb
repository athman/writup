require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }
  
  describe "sign in page" do
    
    before { visit signin_path }
    
    it { should have_title(full_title("Sign in")) }
    it { should have_selector("h2", text: "Sign in") }
    
  end
  
  describe "signing in" do
    
    before { visit signin_path }
    let(:sign_in) { "Sign in" }
    
    describe "with invalid info" do
      
      before { click_button sign_in }
      
      it { should have_title("Sign in") }
      it { should have_selector("div.alert.alert-danger") }
      
      describe "after visiting another page" do
        
        before { click_link "Home" }
        
        it { should_not have_selector("div.alert.alert-danger") }
        
      end
      
    end
    
    describe "with valid info" do
      
      let(:user) { create(:user) }
      
      before do
        fill_in "email",         with: user.email
        fill_in "password",      with: user.password
        click_button sign_in
      end
      
      it { should have_title user.first_name }
      it { should have_link "Profile", href: user_path(user) }
      it { should have_link "Sign out", href: signout_path }
      it { should_not have_link "Sign in", href: signin_path }
      
      describe "followed by signing out" do
        
        before { click_link "Sign out" }
        
        it { should have_link("Sign in") }
        
      end
      
    end
    
  end
  
end