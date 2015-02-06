class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def user_login
    unless session[:userid]
      flash[:notice] = 'you are not logged in'
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end

end
