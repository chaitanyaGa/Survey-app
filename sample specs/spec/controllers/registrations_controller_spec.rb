require 'spec_helper'

describe RegistrationsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context 'normal sign up' do
    it 'update user profile without password' do
      put :update, id: @user, 'user'=>{'name'=>'Name', 'email'=> @user.email,   'password'=>'', 'password_confirmation'=>'', 'current_password'=>''}
      @user.reload
      expect(@user.name).to eq('Name')
    end

    it 'update user profile with password' do
      put :update, id: @user, 'user'=>{'name'=>'Name', 'email'=> @user.email,   'password'=>'josh123', 'password_confirmation'=>'josh123', 'current_password'=>'please'}
      @user.reload
      expect(@user.valid_password?('josh123')).to eq(true)
    end

    it 'cannot update password without current password' do
      put :update, id: @user, 'user'=>{'name'=>'Name', 'email'=> @user.email,   'password'=>'josh123', 'password_confirmation'=>'josh123', 'current_password'=>''}
      @user.reload
      expect(@user.valid_password?('josh123')).to eq(false)
    end
  end

  context 'social media sign up' do
    before(:each) do
      auth = @user.authentications.new
      auth.provider = 'facebook'
      auth.uid = 1
      auth.save!
      @user.password = ''
      @user.save
    end

    it 'update user profile without password' do
      put :update, id: @user, 'user'=>{'name'=>'Name', 'email'=> @user.email,   'password'=>'', 'password_confirmation'=>'', 'current_password'=>''}
      @user.reload
      expect(@user.name).to eq('Name')
    end

    it 'can update password without current_password for first time when swithcing from social media sign in to regular sign in' do
      put :update, id: @user, 'user'=>{'name'=>'Name', 'email'=> @user.email,   'password'=>'josh123', 'password_confirmation'=>'josh123', 'current_password'=>'please'}
      @user.reload
      expect(@user.valid_password?('josh123')).to eq(true)
    end
  end
end
