class PagesController < ApplicationController
  def home
    @post = current_user.posts.build if signed_in?
  end

  def help
  end

  def contact
  end
  
  def about
  end
end
