require 'spec_helper'

describe "PostPages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  before { signin user }
  
  describe "post creation" do
    
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
      
      before { fill_in "post_content", with: Faker::Lorem.paragraph(100) }
      
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Post, :count).by(1)
      end
      
    end
    
  end
  
end
