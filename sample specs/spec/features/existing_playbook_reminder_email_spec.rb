require 'spec_helper'

feature 'Existing Playbook Reminder Email' do
  background do
    # will clear the message queue
    clear_emails
    user = create :user
    @playbook = create :new_plan, :regular, :with_periodicities, user: user
    reminder = create :reminder, :existing_plan, action: @playbook, user: user
    reminder_time = create :reminder_time, reminder: reminder, days_of_week: [Date.today.strftime('%a')], formatted_time: "#{Time.now.strftime("%I:%M %p")} +0530 (Chennai)"
   
    ReminderTime.all.collect(&:send_mails)
    open_email(user.email)
  end

  scenario 'Reminder for existing plan' do
    expect(current_email).to have_content "This is a reminder from v2pal to fill in your #{@playbook.name}"
  end
end
