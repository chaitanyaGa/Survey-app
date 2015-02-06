require 'spec_helper'

describe "Registration" do
  before(:each) do
    create_logged_in_user
    visit edit_user_registration_path
  end

  context '#update_with_password' do
    it 'successfully update password' do
      fill_in 'Password', :with => 'josh123'
      fill_in 'Password confirmation', :with => 'josh123'
      fill_in 'Current password', :with => 'please'
      click_button "Update"
      within(".alert") do
        page.should have_content('Profile updated successfully')
      end
    end

    it 'error while updating password' do
      fill_in 'Password', :with => 'josh123'
      click_button "Update"
      within(".alert") do
        page.should have_content('Please review the problems below:')
      end
    end
  end

  context '#update_without_password' do
    it 'successfully update name' do
      fill_in 'Name', :with => 'ChangeName'
      click_button "Update"
      within(".alert") do
        page.should have_content('Profile updated successfully')
      end
    end
  end
end
