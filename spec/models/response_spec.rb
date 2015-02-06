require 'rails_helper'

RSpec.describe Response, :type => :model do

  before(:each)do
    @response = FactoryGirl.create(:response)
  end

  it "has user" do
    expect(@response.user_id).not_to eq nil
  end
end
