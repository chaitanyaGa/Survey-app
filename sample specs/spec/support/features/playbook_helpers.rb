# spec/support/features/playbook_helpers.rb
module Features
  module PlaybookHelpers

    def create_playbook(attrs)
      visit_playbook
      goto_new_playbook_form
      fill_playbook(attrs)
      submit_form
    end

    def visit_playbook
      visit general_plans_path
      expect(page).to have_content("Playbook")
    end

    def goto_new_playbook_form
      expect(page).to have_css('#new_plan', :text => 'new playbook')
      find('#new_plan').click
    end

    def fill_playbook(attrs)
      find('#plan_name').set(attrs[:name])
      find('#plan_script').set(attrs[:script])
      if attrs[:checkin_same_as_task]
        find('#plan_checkin_same_as_task').set(attrs[:checkin_same_as_task])
        set_select_box('#plan_checkin_period', attrs[:checkin_period])
      end
      show_third_level if attrs[:show_third_level]
      remove_third_level if attrs[:remove_third_level]
      
      #Remove triggers
      if attrs[:remove_trigger]
        clear_triggers
        find('#plan_of_type').set(false)
      end

      if attrs[:level_1]
        find('#magnitude_1').set(attrs[:level_1][:magnitude])
        set_select_box('#unit_1', attrs[:level_1][:unit])
        set_select_box('#unit_2', attrs[:level_2][:unit])
        if attrs[:level_3]
          set_select_box('#unit_3', attrs[:level_3][:unit])
          find('#magnitude_2').set(attrs[:level_2][:magnitude])
        end
      end
      if attrs[:of_type] == 'Context'
        add_triggers(attrs)
        set_select_box('#plan_checkin_period', attrs[:checkin_period])
      end
      fill_reminder(attrs)
    end

    def visit_playbook_form(attrs)
      find('.u_container .u3_normal', :text => attrs[:name]).click
    end

    def set_select_box(id, num)
      opt =  'option['+num+']'
      find(id).find(:xpath, opt).select_option
    end

    def submit_form
      expect(page).to have_selector('button', :text => 'Save Playbook')
      click_button 'Save Playbook'
    end

    def clear_triggers
      all('.label').each do |tag|
        tag.find("[data-role='remove']").click
      end
    end

    def add_triggers(attrs)
      find('#plan_of_type').set(true)
      clear_triggers
      if attrs[:trigger]
        find('.bootstrap-tagsinput input').set(attrs[:trigger])
        if Capybara.current_driver == :selenium
          sleep(0.5)
        end
        find('.bootstrap-tagsinput input').native.send_keys(:return)
      end
    end

    def show_third_level
      find('#add_third_level').click
    end

    def remove_third_level
      find('#remove_third_level').click
      find('#plan_of_type').set(false)
    end

    def flash_message(msg)
      within('.alert') do
        page.should have_content("Playbook #{msg}")
      end
    end

  end
end
