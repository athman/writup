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
  
  it { should be_valid }
  
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
   
end
