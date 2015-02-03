class RegistrationsController < ApplicationController
  def new
    @user  = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'account successfully created'
      redirect_to surveys_path
    else
      flash[:notice] = 'account not created'
      flash[:messag] = @user.errors.full_messages
      render 'new'
    end
  end

  def show
    redirect_to new_registrations_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :age, :gender, :role_id, :password_confirmation, :password )
  end
end
