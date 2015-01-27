require_relative '../../app/models/user.rb'

RSpec.describe User do

=begin 
  before(:each)do
    @p = users(:user1)
    p "=================="
    p @p
    p "=================="
  end
=end

  #let(:p) { users(:user1) }

  it "has role" do
    user = users(:user1)
    p user
  end

  it "fills responses"

  it "voted for option"

  it "answers question"

  it "participate in survey "

  it "doesn't give the answer"

  it "has valid username and password combination"

  it "wrong username and password combination"
  
  it ""
end
