# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  surname         :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_me     :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  
  before do
    @user = User.new(first_name: "Siti", surname: "Paku", email: "sitipaku@gmail.com", password: "secretword", password_confirmation: "secretword")
  end
  
  subject { @user }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:surname) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:admin) }
  it { should respond_to(:posts) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "with admin set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    
    it { should be_admin }
    
  end
  
  describe "When the first_name is not presence" do
    
    before { @user.first_name = " ", @user.surname = " ", @user.email = " " }
    
    it { should_not be_valid }
    
  end
  
  describe "names are too long" do
    
    before { @user.first_name = "a" * 100, @user.surname = "a" * 100 }
    
    it { should_not be_valid }
    
  end
  
  describe "when the email is invalid" do
    
    it "should be invalid" do
      addresses = %w[user@foo,com user:foo.com user@foo+com]
      addresses.each do |invalid_email|
        @user.email = invalid_email
        expect(@user).not_to be_valid
      end
    end
    
  end
  
  describe "when the email is valid" do
    
    it "should be valid" do
      addresses = %w[user@gmail.com USER@foo-bar.com user-me.person@example-company.com user@foo.COM A_US-ER@f.b.org frst.lst@foo.co.jp a+b@baz.cn]
      addresses.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
    
  end
  
  describe "when email is already taken" do
    
    before do
      user_with_duplicate_email = @user.dup
      user_with_duplicate_email.email = @user.email.upcase
      user_with_duplicate_email.save
    end
    
    it { should_not be_valid }
     
  end
  
  describe "when password is not provided" do
    
    before do
      @user = User.new(first_name: "Siti", surname: "Paku", email: "sitipaku@gmail.com", password: " ", password_confirmation: " ")
    end
    
    it { should_not be_valid }
    
  end
  
  describe "password and password confirmation do not match" do
    
    before { @user.password_confirmation = "invalid" }
    
    it { should_not be_valid }
    
  end
  
  describe "return value of authenticate method" do
    
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "with invalid password" do
      
      let(:user_with_invalid_password) { found_user.authenticate("invalid password") }
      
      it { should_not eq user_with_invalid_password }
      specify { expect(user_with_invalid_password).to be_false }
      
    end
    
    describe "with valid password" do
      
      it { should eq found_user.authenticate(@user.password) }
      
    end
    
    describe "with a password that is too short" do
      
      before { @user.password  = @user.password_confirmation = "a" * 5 }
      
      it { should be_invalid }
      
    end
    
    describe "email with mixed case characters" do
      
      let(:mixed_case_email) {"Foo@baR.COM"}
      
      it "should not be saved as lower case" do
        @user.email = mixed_case_email
        @user.save
        expect(@user.reload.email).to eq mixed_case_email.downcase
      end
      
    end
  end
    
  describe "remember token" do
    
    before { @user.save }
    
    its(:remember_me) { should_not be_blank }
    
  end
  
  describe "micropost associations" do
    
    before { @user.save }
    
    let!(:older_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
    end
    
    let!(:newer_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
    end
    
    it "should have the posts in the right order" do
      expect { @user.posts.to_a to eq [newer_post, older_post] }
    end
    
    it "should destroy associated microposts" do
      posts = @user.posts.to_a
      @user.destroy
      expect(posts).not_to be_empty
      posts.each do |post|
        expect(Post.where(id: post.id)).to be_empty
      end
    end
    
    describe "status" do
      
      let!(:unfollowed_post) do
        FactoryGirl.create(:post, user: FactoryGirl.create(:user))
      end
      
      its(:feed) { should include(newer_post) }
      its(:feed) { should include(older_post) }
      its(:feed) { should_not include(unfollowed_post) }
      
    end
    
  end
  
end

