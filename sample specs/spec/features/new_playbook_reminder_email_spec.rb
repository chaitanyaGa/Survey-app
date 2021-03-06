require 'spec_helper'

feature 'New Playbook Reminder Email' do
  background do
    # will clear the message queue
    clear_emails
    user = create :user
    reminder = create :reminder, user: user
    reminder_time = create :reminder_time, reminder: reminder, days_of_week: [Date.today.strftime('%a')], formatted_time: "#{Time.now.strftime("%I:%M %p")} +0530 (Chennai)"
    
    ReminderTime.all.collect(&:send_mails)
    open_email(user.email)
  end

  scenario 'New Playbook reminder' do
    expect(current_email).to have_content "This is a reminder to create new plan"
  end
end

