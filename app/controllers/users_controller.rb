class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Hi #{@user.first_name}, welcome to Writup. We are pleased to have you here (:<). Please check back every often to see new features to the site. We want you to be among the veterans on Writup"
      redirect_to @user
    else
      render 'new'
    end
    
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  private
  
    def user_params
      params.require(:user).permit(:first_name, :surname, :email, :password, :password_confirmation)
    end
    
end
