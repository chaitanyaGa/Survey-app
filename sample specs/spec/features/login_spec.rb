require 'spec_helper'

describe "Login", :js => true, :login => true, driver: :selenium do

  it "sign me up" do
    sign_up
  end
  
  it "sign me out" do
    sign_up
    sign_out
  end

  it "signs me in" do
    sign_up
    sign_out
    sign_in
  end

  context 'Set profile picture' do
    it 'sign up with facebook set profile picture' do
      set_omniauth()
      visit new_user_registration_path
      all(".auth_provider")[0].click
      expect(page).to have_content "Dashboard"
      page.should have_no_xpath("//img[@src='/assets/photos/thumb/missing.png']")
    end

    it 'sign up with email donot set profile picture' do
      sign_up
      expect(page).to have_content "Dashboard"
      page.should have_xpath("//img[@src='/assets/photos/thumb/missing.png']")
    end
  end

  #Every time Facebook Connect redirects you to another URL it adds #_=_ to redirect_uri.
  it 'facebook login should land on dashboard page successfully' do
    sign_up
    visit balances_path
    visit '/#_=_'
    expect(page).to have_content "Dashboard"
    expect(page).to have_content "Episode"
  end

end
