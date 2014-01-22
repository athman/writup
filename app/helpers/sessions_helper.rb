module SessionsHelper
  
  def sign_in user
    remember_me = User.new_remember_me
    cookies.permanent[:remember_me] = remember_me
    user.update_attribute(:remember_me, User.encrypt(remember_me))
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user= user
    @current_user = user
  end
  
  def current_user
    remember_me = User.encrypt(cookies[:remember_me])
    @current_user ||= User.find_by(remember_me: remember_me)
  end
  
  def current_user? user
    user == current_user
  end
  
  def signout
    current_user.update_attribute(:remember_me, User.encrypt(User.new_remember_me))
    self.current_user = nil
  end
  
  def redirect_back_or default
    redirect_to (session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.url if request.get?
  end
  
end
