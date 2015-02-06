require 'spec_helper'

describe 'Reminder', js: true, driver: :selenium do
  before(:each) do
    create_logged_in_user
  end

  context 'Reminder CRUD' do
    it 'should create new Reminder' do
      create_reminder(reminder_attr)
      find('.u_container .u3_normal', :text => 'Reminder').click
      check_reminder_content(reminder_attr)
    end

    it 'should update reminder'do
      create_reminder(reminder_attr)
      find('.u_container .u3_normal', :text => 'Reminder').click
      attrs = {reminder_times: {formatted_time: '02:30 AM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Wed', 'Fri']}}
      fill_reminder(attrs)
      find('.save').click
      sleep(1)
      find('.u_container .u3_normal', :text => 'Reminder').click
      check_reminder_content(attrs)
    end

    it 'should delete reminder' do
      create_reminder(reminder_attr)
      find('.u_container .u3_normal', :text => 'Reminder').hover
      find('.delete').click
      accept_alert
      accept_alert
      expect(page).to have_css('.u_container', :count => 1)
    end
  end

end
