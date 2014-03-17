require 'spec_helper'
  
describe "Pages" do

  it "should have the right links on the layout" do
    
    visit root_path
    
    #click_link "Home"
    #expect(page).to have_title(full_title(""))
    
    click_link "About"
    expect(page).to have_title(full_title("About"))
    
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    
    click_link "Sign up"
    expect(page).to have_title(full_title("Sign up"))
    
    click_link "Writup"
    expect(page).to have_title(full_title(""))
    
  end
  
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector("h1", text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  describe "Home page" do
    
    before { visit root_path }
    
    let(:heading) { 'Writup' }
    let(:page_title) { '' }
    
    it_should_behave_like "all static pages"
    it { should_not have_title("home") }
    it { should have_content("Welcome to Writup") }
    it { should have_selector("a", text: "Sign in") }
    it { should have_selector("a", text: "Sign up") }
    
    describe "for signed in users" do
      
      let(:user) { FactoryGirl.create(:user) }
      
      before do
        FactoryGirl.create(:post, user: user)
        FactoryGirl.create(:post, user: user)
        signin user
        visit root_path
      end 
      
      it "should render the user's feed" do
        user.feed.each do |post|
          expect(page).to have_selector("div##{post.id}", text: post.content)
        end
      end
      
      describe "follower/following counts" do
        
        let(:other_user) { FactoryGirl.create(:user) }
        
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
        
      end
      
    end
    
  end
  
  describe "Help page" do
    
    before { visit help_path }
    
    let(:heading) { "Help" }
    let(:page_title) { "Help" }
    
    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    
    before { visit about_path }
    
    let(:heading) { "About" }
    let(:page_title) { "About" }
    
    it_should_behave_like "all static pages"
    
  end
  
  describe "Contact page" do
    
    before { visit contact_path }
    
    let(:heading) { "Contact" }
    let(:page_title) { "Contact" }
    
    it_should_behave_like "all static pages"
    
  end
  
end
