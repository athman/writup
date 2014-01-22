require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    before(:each) do
      
      signin FactoryGirl.create(:user)
      visit users_path
      
    end
    
    it { should have_title "All writers" }
    it { should have_content "All writers" }
    
    describe "pagination" do
      
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector("div.pagination") }  
      
      it "should list each user" do
        User.paginate(page: 1) do |user|
          expect(page).to have_selector("h4", user.first_name)
        end
      end
      
    end
    
    describe "delete links" do
      
      it { should_not have_link("Delete") }
      
      describe "as an admin user" do
        
        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          
          signin admin
          visit users_path
          
        end
        
        it { should have_link("Delete", href: user_path(User.first)) }
        
        it "should be able to delete another user" do
          expect do
            click_link("Delete", match: :first)
          end.to change(User,  :count).by(-1)
        end
        
        it { should_not have_link("Delete", user_path(admin)) }
        
      end
      
    end
    
  end
  
  describe "Sign up page" do
    
    before { visit signup_path }
    let(:submit) { "Sign up" }
    
    it { should have_title(full_title("Sign up")) }
    it { should have_selector("h2", :text => "Sign up") }
    
    describe "with invalid information" do
      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        
        before { click_button submit }
        
        it { should have_title("Sign up") }
        it { should have_content("Sorry") }
          
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
      
      describe "after saving the user" do
        
        before { click_button submit }
        let(:user) { User.find_by(email: "alice@wonderland.com") }
        
        it { should have_title(full_title("Alice")) }
        it { should have_link("Sign out") }
        it { should have_selector("div.alert.alert-success.alert-dismissable") }
        
      end
      
    end
    
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.first_name) }
    it { should have_title(full_title(user.first_name)) }
    
  end
  
  describe "edit" do
    
    let(:user) { FactoryGirl.create(:user) }
    before do
      signin user
      visit edit_user_path(user)
    end
    
    describe "page" do
      
      it { should have_selector("h2", "Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link "Change your gravatar", href: "http://gravatar.com/emails" }
      
    end
    
    describe "with invalid information" do
      
      before { click_button "Save changes" }
      
      it { should have_content("Ooops! We couldn't save the changes") }
      
    end
    
    describe "with valid info" do
      
      let(:new_first_name) { "Newfirstname" }
      let(:new_surname) { "Newsurname" }
      
      before do
        
        fill_in "user_first_name",            with: new_first_name
        fill_in "user_surname",               with: new_surname
        fill_in "user_email",                 with: user.email
        fill_in "user_password",              with: user.password
        fill_in "user_password_confirmation", with: user.password
        click_button "Save changes"
        
      end
      
      it { should have_title(full_title(new_first_name)) }
      it { should have_selector("div.alert.alert-success.alert-dismissable") }
      it { should have_link("Sign out", href: signout_path) }
      specify { expect(user.reload.first_name).to eq  new_first_name }
      specify { expect(user.reload.surname).to eq new_surname }
      
    end
    
  end
  
end
