require 'rails_helper'

RSpec.describe User, :type => :model do
=begin
  fixtures :users

  example "sample spec" do
    user = users(:user1)
    p user.inspect
  end
=end
  before(:each)do
    @user = FactoryGirl.create(:user, :name => "Rails")
  end

  it "has role" do
    p @user
  end
 #   puts @user.inspect

  it "has password and username"

  it "participate in survey"


end
