require 'rails_helper'

RSpec.describe User, :type => :model do
=begin
  fixtures :users

  example "sample spec" do
    user = users(:user1)
    p user.inspect
  end
=end

  context '#admin'do
    before(:each)do
      @user = FactoryGirl.create(:user, :name => "Rails")
    end

    it " has role 1" do
      expect(@user.role_id).to eq 1
    end
  end

  context '#normal user' do

    before(:each)do
      @user = FactoryGirl.create(:user, :role_id => 2)
    end

    it "has password "do
      expect(@user.authenticate('abc')).to be == @user
    end

    it 'has username' do
      expect(@user.username).not_to eq nil
    end

    it "participate in survey"do
    end
  end

end
