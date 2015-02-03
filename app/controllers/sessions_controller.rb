class SessionsController < ApplicationController
  def new
   @login = User.new
  end

  def create
    puts '***************************************************************'
    puts params
    puts '***************************************************************'
    @login = User.find_by_username(params[:user][:username])

    if @login.nil?
      flash[:notice] = 'invalid username'
      redirect_to new_sessions_path
    elsif @login.authenticate(params[:user][:password])
      flash[:notice] = 'you successfully logged in'
      session[:userid] =  @login.id
      redirect_to surveys_path
    else
      flash[:notice] = 'invalid  password'
      redirect_to new_sessions_path
    end
  end

  def destroy
    flash[:notice] = 'you are successfully loggged of'
    reset_session
    redirect_to new_sessions_path
  end
end
