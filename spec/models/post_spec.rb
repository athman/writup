# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#

require 'spec_helper'

describe Post do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @post = user.posts.build(content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mi lacus, accumsan ut magna at, eleifend auctor arcu. Mauris varius ipsum eget suscipit ultricies. Pellentesque felis quam, sagittis quis elit nec, commodo facilisis velit. Nam vitae faucibus ipsum. Nullam ut dolor tincidunt, sodales mi sed, cursus elit. Nunc convallis purus tempor lorem tristique faucibus. Nam arcu magna, pellentesque in risus sed, laoreet iaculis diam. Proin hendrerit, eros sit amet tristique semper, urna lectus blandit lorem, quis venenatis nisi neque non ante. Proin nec molestie elit. Mauris tristique tristique nisl ac pellentesque. In vel metus tortor. Quisque quis commodo mi.") 
  end
  
  subject { @post }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  
  
  it { should be_valid }
  
  describe "when the user id is not presernt" do
    
    before { @post.user_id = nil }
    
    it { should_not be_valid }
    
  end
  
  describe "with blank content" do
    
    before { @post.content = "" }
    
    it { should_not be_valid }
    
  end
  
  describe "with content that is too short" do
    
    before { @post.content = "a" * 140 }
    
    it { should_not be_valid }
    
  end
  
end
