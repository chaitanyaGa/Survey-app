module Features
  module ReminderHelpers
    def create_reminder(attrs)
      visit reminder_path
      expect(page).to have_content "Reminders"
      find('.new_map').click
      find(:css, "#reminder_name").set(attrs[:name])
      find('#action_type').find(:xpath, "option[#{attrs[:reminder_type]}]").select_option
      fill_reminder(attrs)
      find('.save').click
      sleep(1)
    end

    def fill_reminder(attrs)
      reminder_time = attrs[:reminder_times]
      if reminder_time
        if attrs[:name] == 'Playbook'
          # On playbook page
          find(:css, "#plan_set_reminder").set(true)
        end
        within('.reminder_times') do
          page.execute_script("$('.time').val('#{reminder_time[:formatted_time]}')")
          find(:css, ".repeat_box").set(reminder_time[:repeat])
          find(:css, "#enabled").set(reminder_time[:enabled])
          find('.select_unselect_link').click
          find('.select_unselect_link').click
          reminder_time[:days_of_week].each do |day|
            find_button(day[0]).click
          end
        end
      end
    end

    def check_reminder_content(attrs)
      if reminder = attrs[:reminder_times]
        within('.reminder_times') do
          page.should have_xpath("//input[@value='#{reminder[:formatted_time]}']")
          if reminder[:repeat]
            find('.repeat_box').should be_checked
          else
            find('.repeat_box').should_not be_checked
          end
          if reminder[:enabled]
            find('#enabled').should be_checked
          else
            find('#enabled').should_not be_checked
          end
          reminder[:days_of_week].each do |day|
            expect(page).to have_selector('button', day[0])
          end
        end
      end
    end

    def reminder_attr
      {name: 'Reminder', reminder_type: 1, reminder_times: {formatted_time: "#{Time.now.strftime("%I:%M %p")} +0530 (Chennai)", repeat: true, enabled: true, days_of_week: ['Mon', 'Wed']}}
    end
  end
end
