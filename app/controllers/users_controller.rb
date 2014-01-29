class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
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
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile was updated successfully"
      redirect_to @user
    else
      render "edit"
    end
    
  end
  
  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "The user has been deleted successfully"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:first_name, :surname, :email, :password, :password_confirmation)
    end
    
    
    # Before filters
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Oops! You need to sign in first"
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
