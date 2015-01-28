require 'rails_helper'

RSpec.describe Response, :type => :model do

  before(:each)do
    @response = FactoryGirl.create(:response)
  end

  it "has user" do
    p @response
  end
end
