require 'spec_helper'

describe MainController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'quotes'" do
    it "returns http success" do
      get 'quotes'
      response.should be_success
    end
  end

  describe "GET 'B.E.N.T. maps'" do
    it "returns http success" do
      get 'bent'
      response.should be_success
    end
  end

end
