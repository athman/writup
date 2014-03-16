require 'spec_helper'

describe "PostPages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  before { signin user }
  
  describe "post creation" do
    
    before { visit root_path }
    
    describe "with invalid info" do
      
      it "should not create a post" do
        expect { click_button "Post" }.not_to change(Post, :count)
      end
      
      describe "error message" do
        
        before { click_button "Post" }
        
        it { should have_content("Error") }
        
      end
      
    end
    
    describe "with valid information" do
      
      before do
        fill_in "post_title", with: "Lorem Ipsum Dolor Sit Amet"
        fill_in "post_content", with: Faker::Lorem.paragraph(100)
      end
      
      it "should create a post" do
        expect { click_button "Post" }.to change(Post, :count).by(1)
      end
      
    end
    
  end
  
  describe "post destruction" do
    
    before { FactoryGirl.create(:post, user: user) }
    
    describe "as correct user" do
      
      before { visit root_path }
      
      it "should delete a micropost" do
        expect { click_link "Delete" }.to change(Post, :count).by(-1)
      end
      
    end
    
  end
  
end
