require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    before(:each) do
      
      signin user
      visit users_path
      
    end
    
    it { should have_title "All writers" }
    it { should have_content "All writers" }
    
    describe "pagination" do
      
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector("div.pagination") }  
      
      it "should list each user" do
        User.paginate(page: 1).each do |user|
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
        
        it { should_not have_link("Delete", href: user_path(admin)) }
        
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
    let!(:p1) { FactoryGirl.create(:post, user: user, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mi lacus, accumsan ut magna at, eleifend auctor arcu. Mauris varius ipsum eget suscipit ultricies. Pellentesque felis quam, sagittis quis elit nec, commodo facilisis velit. Nam vitae faucibus ipsum. Nullam ut dolor tincidunt, sodales mi sed, cursus elit. Nunc convallis purus tempor lorem tristique faucibus. Nam arcu magna, pellentesque in risus sed, laoreet iaculis diam. Proin hendrerit, eros sit amet tristique semper, urna lectus blandit lorem, quis venenatis nisi neque non ante. Proin nec molestie elit. Mauris tristique tristique nisl ac pellentesque. In vel metus tortor. Quisque quis commodo mi.") }
    let!(:p2) { FactoryGirl.create(:post, user: user, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mi lacus, accumsan ut magna at, eleifend auctor arcu. Mauris varius ipsum eget suscipit ultricies. Pellentesque felis quam, sagittis quis elit nec, commodo facilisis velit. Nam vitae faucibus ipsum. Nullam ut dolor tincidunt, sodales mi sed, cursus elit. Nunc convallis purus tempor lorem tristique faucibus. Nam arcu magna, pellentesque in risus sed, laoreet iaculis diam. Proin hendrerit, eros sit amet tristique semper, urna lectus blandit lorem, quis venenatis nisi neque non ante. Proin nec molestie elit. Mauris tristique tristique nisl ac pellentesque. In vel metus tortor. Quisque quis commodo mi.") }
    
    before { visit user_path(user) }
    
    it { should have_content(user.first_name) }
    it { should have_title(full_title(user.first_name)) }
    
    describe "posts" do
      
      it { should have_content(p1.content) }
      it { should have_content(p2.content) }
      it { should have_content(user.posts.count) }
      
    end
    
    describe "follow/ unfollow buttons" do
      
      let(:other_user) { FactoryGirl.create(:user) }
      
      before { signin user }
      
      describe "following a user" do
        
        before { visit user_path(other_user) }
        
        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        
        it "should increment the other users followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
        
        describe "toggling the button" do
          
          before { click_button "Follow" }
          
          it { should have_xpath("//button/span[@class='glyphicon glyphicon-minus']") }
          
        end
        
      end
      
      describe "Unfollowing a user" do
        
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        
        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end
        
        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        
        describe "toggling the button" do
          
          before { click_button "Unfollow" }
          
          it { should have_xpath("//button/span[@class='glyphicon glyphicon-plus']") }
          
        end
        
      end
      
    end
    
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
    
    describe "forbidden attributes" do
      
      let(:params) do
        { user: { admin: true, password: user.password, password_confirmation: user.password } }
      end
      
      before do
        signin user, no_capybara: true
        patch user_path(user), params
      end
      
      specify { expect(user.reload).not_to be_admin }
      
    end
    
  end
  
  describe "following/ followers" do
    
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    
    before {  user.follow!(other_user) }
    
    describe "followed users" do
      before do
        signin user
        visit following_user_path(user)
      end
      
      it { should have_title(full_title("Following")) }
      it { should have_selector("h3", text: "Following") }
      it { should have_link(other_user.first_name, href: user_path(other_user)) }
      
    end
    
    describe "followers" do
      
      before do
        signin other_user
        visit followers_user_path(other_user)
      end
      
      it { should have_title(full_title("Followers")) }
      it { should have_selector("h3", text: "Followers") }
      it { should have_link(user.first_name, href: user_path(user)) }
      
    end
    
  end
  
end
