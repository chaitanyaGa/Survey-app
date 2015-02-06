require 'spec_helper'

describe ReminderTime do
  it 'should consider daylight saving while setting time' do
    offset = 6
    (1..11).each do |i|
      formatted_time =  "#{i}:00 am -0#{offset}:00"
      utc_hour = (i+offset)%12
      utc_hour = utc_hour.zero? ? 12 : utc_hour
      utc_time = Time.strptime("01/01/2000 #{utc_hour}:00 am -00:00",'%m/%d/%Y %I:%M %p %z') 
      r = ReminderTime.new(formatted_time: formatted_time)
      r.set_time
      r.time == utc_time
    end
  end

  context 'One Time Email' do
    it '#are_all_email_sent?' do
      time = Time.now#Date.today
      days = [(time + 3.day).strftime('%a'), (time + 5.day).strftime('%a'), (time + 7.day).strftime('%a')]
      user = create(:user)
      attrs = {'name'=>'Reminder Name', 'action_type'=>'Entry', 'action_id'=>'', 'action_name'=>'', 'active'=>false, 'reminder_times_attributes'=>[{'formatted_time'=>'12:00 AM +0530', 'repeat'=>false, 'enabled'=>true, '_destroy'=>'false', 'days_of_week'=> days}]}
      reminder = user.reminders.create!(attrs)
      rt = reminder.reminder_times.last
      rt.are_all_email_sent?.should eq(false) 

      ActiveRecord::Base.record_timestamps = false
      rt.update_attribute(:updated_at, time - 1.day)
      ActiveRecord::Base.record_timestamps = true
      rt.are_all_email_sent?.should eq(false) 

      ActiveRecord::Base.record_timestamps = false
      rt.update_attribute(:updated_at, time - 2.day)
      ActiveRecord::Base.record_timestamps = true
      rt.are_all_email_sent?.should eq(false) 

      ActiveRecord::Base.record_timestamps = false
      rt.update_attribute(:updated_at, time - 3.day)
      ActiveRecord::Base.record_timestamps = true
      rt.are_all_email_sent?.should eq(false) 

      ActiveRecord::Base.record_timestamps = false
      rt.update_attribute(:updated_at, time - 4.day)
      ActiveRecord::Base.record_timestamps = false
      rt.are_all_email_sent?.should eq(false) 

      ActiveRecord::Base.record_timestamps = false
      rt.update_attribute(:updated_at, time - 5.day)
      ActiveRecord::Base.record_timestamps = true
      rt.are_all_email_sent?.should eq(true) 
    end
  end
end
