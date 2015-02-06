require 'spec_helper'

describe 'Playbook', :js => true, driver: :selenium do
  before(:each) do
    @user =  create_logged_in_user
  end

  context 'Playbook of type regular' do
    context 'successfull creation' do
      it 'two_level_periodcity_playbook' do
        attrs = {name: 'two_level_periodcity_playbook create', show_third_level: false, checkin_same_as_task: true, checkin_period: '4', level_1: {magnitude: 5, unit: '5'}, level_2: {unit: '2'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
        create_playbook(attrs)
        flash_message('created')
        expected_container_count(2)
        expect_container_with_plan_name(attrs)
        check_content(attrs)
        check_points_and_badges(0, 1)
      end

      it 'three_level_periodcity_playbook' do
        attrs = {name: 'three_level_periodcity_playbooki create', show_third_level: true, checkin_same_as_task: false, level_1: {magnitude: 1, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
        create_playbook(attrs)
        flash_message('created')
        expected_container_count(2)
        expect_container_with_plan_name(attrs)
        check_content(attrs)
      end
    end

    #should not create if magnitude has negative value
    it 'unsuccessfull creation' do
      attrs = {name: 'unsuccessfull creation', show_third_level: true, level_1: {magnitude: -1, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      create_playbook(attrs)
      accept_alert
    end

    context 'successfull update' do
      it 'Update from 2 level to 3 level' do
        attrs = {name: 'two level', show_third_level: false, level_1: {magnitude: 3, unit: '5'}, level_2: {unit: '2'}}
        create_playbook(attrs)

        expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
        visit_playbook_form(attrs)

        attrs = {name: 'update from 2 level to 3 level', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}}
        update_playbook(attrs)
        flash_message('updated')
        check_content(attrs)
      end

      it 'Update from 3 level to 2 level' do
        attrs = {name: '3 level', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}}
        create_playbook(attrs)

        expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
        visit_playbook_form(attrs)

        attrs = {name: 'update from 3 level to 2 level', show_third_level: false, remove_third_level: true, level_1: {magnitude: 3, unit: '5'}, level_2: {unit: '2'}}
        update_playbook(attrs)
        flash_message('updated')
        check_content(attrs)
      end
    end

    #should not update if magnitude is higher than max-magnitude value
    it 'unsuccessfull update' do
      attrs = {name: 'unsuccessfull update', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      create_playbook(attrs)

      expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
      visit_playbook_form(attrs)

      attrs = {name: 'New Name Changed', level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 6, unit: '2'}, level_3: {unit: '2'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      update_playbook(attrs)
      accept_alert
    end
  end

  context 'Playbook of type context' do
    it 'successfull creation' do
      attrs = {name: 'successfull creation', of_type: 'Context', trigger: 'Anger', checkin_period: '3'}
      create_playbook(attrs)
      flash_message('created')
      expected_container_count(2)
      expect(page).to have_css('.u_container', text: attrs[:name])
      check_content(attrs)
    end

    #should not create playbook if no trigger is added
    it 'unsuccessfull creation' do
      attrs = {name: 'unsuccessfull creation', of_type: 'Context', checkin_period: '3'}
      create_playbook(attrs)
      accept_alert
    end

    it 'successfull update' do
      attrs = {name: 'successfull create',of_type: 'Context', trigger: 'Anger', checkin_period: '3'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)
      attrs = {name: 'successfull update', of_type: 'Context', trigger: 'Bored', checkin_period: '5'}
      update_playbook(attrs)
      flash_message('updated')
      check_content(attrs)
    end

    #should not create playbook if no trigger is added
    it 'unsuccessfull update' do
      attrs = {name: 'successfull create CP', of_type: 'Context', trigger: 'Anger', checkin_period: '3'}
      create_playbook(attrs)
      expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
      visit_playbook_form(attrs)
      attrs = {name: 'Context Plan name Changed after update', of_type: 'Context', checkin_period: '5'}
      update_playbook(attrs)
      accept_alert
    end
  end

  it 'delete playbook' do
    attrs = {name: 'Delte playbook', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}}
    create_playbook(attrs)
    visit_playbook_form(attrs)
    find('.delete').click
    accept_alert
    flash_message('deleted')
    expected_container_count(1)
  end

  context '#reminders' do
    it 'create reminder on playbook and verify it on reminder page' do
      attrs = {name: 'Playbook', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, reminder_times: {formatted_time: '04:30 PM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Mon', 'Wed', 'Fri']}}
      create_playbook(attrs)
      visit_reminder_page
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)
      check_reminder_content(attrs)
    end

    it 'update reminder from playbook and verify playbook page itself' do
      attrs = {name: 'Playbook', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, reminder_times: {formatted_time: '04:30 PM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Mon', 'Wed']}}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)

      visit_playbook_form(attrs)
      check_reminder_content(attrs)

      attrs[:reminder_times] =  {formatted_time: '09:30 PM +0530 (Chennai)', repeat: false, enabled: false, days_of_week: ['Fri']}
      attrs[:show_third_level] = false
      visit_playbook
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)
      update_playbook(attrs)
      expect_container_with_plan_name(attrs)

      visit_playbook_form(attrs)
      check_reminder_content(attrs)
    end
  end

  context 'Switch from' do
    it 'regular plan to context plan' do
      attrs = {name: 'Regular Plan', checkin_same_as_task: true, checkin_period: '4'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)

      attrs = {name: 'Changed to context plan', of_type: 'Context', trigger: 'Anger [behavior]', checkin_period: '2' }
      update_playbook(attrs)
      flash_message('updated')
      check_content(attrs)
    end

    it 'context plan to regular plan' do
      attrs = {name: 'Context plan', of_type: 'Context', trigger: 'Anger [behavior]', checkin_period: '2'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)

      attrs = {name: 'Context changed to Regular Plan', remove_trigger: true, level_1: {magnitude: 5, unit: '5'}, level_2: {unit: '2'}}
      update_playbook(attrs)
      flash_message('updated')
      check_content(attrs)
    end
  end

  context 'Auto save Playbook' do
    it "should auto save playbook on edit page" do
      attrs = {name: 'Regular Plan'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)
      visit_playbook_form(attrs)
      find('#plan_name').set('Updated Plan')
      # wait for auto save
      sleep 62
      visit_playbook
      expect_container_with_plan_name({name: 'Updated Plan'})
    end
  end

  context 'Create playbook with custom entry item type as trigger' do
    it 'should save playbook after selecting custom entry item type' do
      @user.user_entry_item_types.create_entry({"describe"=>"Insights", "suggest"=>"example: play", "visible"=>true}, 'Insights')
      attrs = {name: 'Context plan', of_type: 'Context', trigger: 'Anger [insights]', checkin_period: '2'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)

      attrs = {name: 'Context plan 2', of_type: 'Context', trigger: 'Anger [insights]', checkin_period: '2'}
      create_playbook(attrs)
      expect_container_with_plan_name(attrs)
    end
  end

  context 'Assign points and Badges for Playbook' do
    
    it 'should create, update and destroy playbook and check points are given accordingly' do
      # create playbook with highest periodicity of week
      attrs = {name: 'Playbook', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, reminder_times: {formatted_time: '04:30 PM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Mon', 'Wed', 'Fri']}}
      create_playbook(attrs)
      # 20 points should be given 
      check_points_and_badges(20, 1)
     
      # update highest periodicity to day 
      visit_playbook_form(attrs)
      attrs = {name: 'Playbook', show_third_level: false, remove_third_level: true, level_1: {magnitude: 5, unit: '1'}, level_2: {magnitude: 4, unit: '1'}}
      update_playbook(attrs)
      # 30 points should be added, making point count to 50
      check_points_and_badges(50, 1)

      # remove reminder from playbook
      visit_playbook_form(attrs)
      find('#plan_set_reminder').click
      click_button 'Save Playbook'
      sleep(1)
      # delete points but donot delete badge
      check_points_and_badges(0, 1)

      # delete playbook
      visit_playbook_form(attrs)
      find('.delete').click
      accept_alert
      # delete badge
      check_points_and_badges(0, '')

    end 
  end
  ########################################################################################################################
  ###############################################- METHODS ###############################################################
  def check_points_and_badges(points_count, badges_count)
    page.should have_css('#points', :text => points_count)
    if badges_count.present?
      page.should have_css('#bronze_badge_count', :text => badges_count)
    else
      page.should_not have_css('#bronze_badge_count')
    end
  end

  def visit_reminder_page
    visit reminder_path
    expect(page).to have_content("Reminders")
  end

  def expected_container_count(num)
    expect(page).to have_css('.u_container', :count => num)
  end

  def expect_container_with_plan_name(attrs) 
    expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
  end

  def check_content(attrs)
    expect_container_with_plan_name(attrs)
    visit_playbook_form(attrs)
    page.has_field?('#plan_name', :with => attrs[:name])
    page.has_field?('#plan_script', :with => attrs[:script])
    if attrs[:level_1]
      page.has_field?('#unit_1', :with => attrs[:level_1][:unit])
      page.has_field?('#magnitude_1', :with => attrs[:level_1][:magnitude])
      page.has_field?('#unit_2', :with => attrs[:level_2][:unit])
      if attrs[:checkin_same_as_task].present?
        if attrs[:checkin_same_as_task]
          has_checked_field?('#plan_checkin_same_as_task')
        else
          has_no_checked_field?('#plan_checkin_same_as_task')
        end
      end
      if attrs[:level_3]
        page.should have_no_css('#add_third_level')
        find_link('Remove').visible?.should be_true
        page.has_field?('#unit_3', :with => attrs[:level_3][:unit])
        page.has_field?('#magnitude_2', :with => attrs[:level_2][:magnitude])
      else
        page.should have_css('#add_third_level')
        page.should have_no_content('Remove')
        find_link('at least').visible?.should be_true
      end
    end

    if more_setting = attrs[:more_setting]
      find('#more_settings').click
      if period = more_setting[:active_period]
        page.has_field?('#plan_starttime', :with => period[:start_date])
        page.has_field?('#plan_endtime', :with => period[:end_date])
      end
    end
  end

  def update_playbook(attrs)
    fill_playbook(attrs)
    submit_form
  end
end
