require 'spec_helper'

describe "application helper" do
  
  describe "full_title" do
    
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end
    
    it "should include the base title" do
      expect(full_title("foo")).to match(/^Writup/)
    end
    
    it "should not include :: for the home page" do
      expect(full_title("")).not_to match(/::/)
    end
    
  end
  
end