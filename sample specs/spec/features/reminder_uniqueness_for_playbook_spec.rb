require 'spec_helper'

describe "Reminder", js: true, driver: :selenium do
  before(:each) do
    @user = create_logged_in_user
    setup
  end

  def setup
    @playbook = create :new_plan, :regular, :with_periodicities, user: @user
    @reminder = create :reminder, :existing_plan, action: @playbook, user: @user
  end

  it "should redirect to old reminder when adding reminder to plan with existing reminder" do
    visit reminder_path
    expect(page).to have_content "Reminders"
    expect(page).to have_selector('span', text: @reminder.name)
    find('.new_map').click
    find('#action_type').find(:xpath, 'option[3]').select_option # select playbook
    find('#new_existing_opt').click # click existing checkbox
    find('#action_name').click  #click input text box for available playbook
    
    sleep(1) # wait for typeahead
    
    all(".typeahead li").first.click

    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content "Reminder"
    find('#reminder_name').value.should == @reminder.name
    find('#action_name').value.should == @playbook.name
  end
end
