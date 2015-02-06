require 'spec_helper'

describe 'PlaybookLogging', js: true, driver: :selenium do
  before(:each) do
    @user =  create_logged_in_user
  end

  context 'Playbook Logging of type regular' do
    it 'should create logging for regular plan' do
      create_regular_playbook_loggings
      check_regular_playbook_loggings
    end

    it 'should show added and pending task if any' do
      create_playbook({name: 'Name'})
      sleep(1)
      add_regular_log
      new_plan = @user.new_plans.last
      ## Pending Logs date = Todays date - Last log's begin_timestamp
      ## So to show pending logs we need to change begin_timestamp column of log added 
      ## and last_logged_at column of new_plan
      new_plan.update_column(:last_logged_at, Date.today - 5.day)
      log = new_plan.new_plan_tasks.last
      log.update_column(:begin_timestamp, Date.today - 5.day)

      #Refresh page
      visit balances_path
      visit_playbook
      find('.btn-medium', :text => 'Log Task Done').click
      date = Date.today
      1..6.times do |i|
        page.should have_selector('td', :text => 'times' + (date - i.day).strftime("%b %d %Y"))
      end
      page.should have_selector('[name=task_amount_done]', :count => 6)
    end

    it 'should load previous loggings' do
      attrs = regular_playbook_attrs 
      attrs[:level_1][:unit] = '4' # hour
      attrs[:level_2][:unit] = '1' # day
      attrs[:level_3] = nil
      attrs[:remove_third_level] = true
      create_playbook(attrs)
      sleep(1)
      reset_playbook_created_date
      visit general_plans_path
      find('.btn-medium', :text => 'Log Task Done').click
      page.should have_selector('span', :text => 'hours', :count => 5)
      all('.amount').last.click
      all('.amount').last.set(1)
      all('.save').first.click
      sleep(1)
      page.should have_selector('span', :text => 'hours', :count => 3)
      find('.load_more').click
      page.should have_selector('span', :text => 'hours', :count => 5)
    end
  end

  context 'Playbook Expectation Graph' do
    it 'should show expectation graph for regular playbook' do
      create_regular_playbook_loggings
      sleep(1)
      find('.log_name .icon').click
      find('svg').hover
      expect(page).to have_content "Expect Amount: 4"
      expect(page).to have_content "Actual Amount: 1"
    end
  end

  context 'Playbook Loggings Graph' do
    it 'should show loggings graph for regular playbook' do
      create_regular_playbook_loggings
      sleep(1)
      find('.log_name .icon').click
      find('a', :text => 'Loggings').click
      find('svg').hover
      expect(page).to have_content "Amount: 1" 
    end
    
    it 'should show loggings graph for context playbook' do
      create_context_playbook_loggings
      sleep(1)
      find('span', :text => 'Anger [circumstance]').click
      find('td .icon').click # click graph icon
      find('svg').hover
      expect(page).to have_content "Context Amount: 1"
      expect(page).to have_content "Task Amount: 1"
    end
  end

  context 'Loggings points' do
    it 'should add 5 points for adding logging to weekly periodicity playbook' do
      create_regular_playbook_loggings
      check_points(5)
    end
    
    it 'should add 1 points for adding logging to daily periodicity playbook' do
      attr = {name: 'Name', show_third_level: false, level_1: {magnitude: 5, unit: '1'}, level_2: {magnitude: 4,  unit: '1'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      
      create_playbook(attr)
      sleep(1)
      find('.btn-medium', :text => 'Log Task Done').click
      find('.amount').click
      find('.amount').set(1)
      all('.save').first.click
      
      check_points(1)
    end
    
    it 'should add 2 points for adding 2 logging to daily periodicity playbook' do
      attr = {name: 'Name', show_third_level: false, level_1: {magnitude: 5, unit: '1'}, level_2: {magnitude: 4,  unit: '1'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      
      create_playbook(attr)
      sleep(1)

      playbook = NewPlan.last
      playbook.created_at = playbook.created_at - 10.day
      playbook.save

      visit root_path
      visit general_plans_path(anchor: "new_plan/tasks")
      sleep(1)
      all('input[name="task_amount_done"]').first.click
      all('input[name="task_amount_done"]').first.set(1)
      all('input[name="task_amount_done"]').last.click
      all('input[name="task_amount_done"]').last.set(1)
      all('.save').first.click

      check_points(2)
    end
    
    it 'should add 45 points for adding logging to monthly logging frequency context playbook' do
      create_context_playbook_loggings
      check_points(45) # 20 point for context playbook + 25 points for 100% loggings
    end
    
  end

  context 'Playbook Logging of type context' do
    it 'should create logging for context plan' do
      create_context_playbook_loggings
      check_context_playbook_loggings
    end
  end

  context 'Playbook periodicity' do
    it 'should not be changed if logging for playbook is present' do
      create_regular_playbook_loggings
      # visit playbook index
      all('.btn-medium', :text => 'Playbook').first.click
      # click playbook to edit
      find('.u_container .u3_normal', :text => 'Name').click
      # update magnitude of level_1 periodicity
      find('#magnitude_1').set(2)
      submit_form
      accept_alert
    end
  end

  context 'Logging Unit' do
    it 'should be changed if playbook periodicity is updated' do
      create_playbook(regular_playbook_attrs)
      sleep(1)
      find('.btn-medium', :text => 'Log Task Done').click
      page.should have_selector('span', :text => 'week')
      
      # visit playbook index
      all('.btn-medium', :text => 'Playbook').first.click
      # click playbook to edit
      find('.u_container .u3_normal', :text => 'Name').click
      
      # new attributes
      attrs = {name: 'Name', remove_third_level: true, level_1: {magnitude: 5, unit: '4'}, level_2: {magnitude: 2, unit: '3'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
      fill_playbook(attrs)
      click_button 'Save Playbook'
      
      sleep(3)
      # go to loggings page
      find('.btn-medium', :text => 'Log Task Done').click
      page.should have_selector('span', :text => 'hours') # log unit is second highest periodicity unit
    end
  end

  def check_points(points_count)
    page.should have_css('#points', :text => points_count)
  end

  def create_regular_playbook_loggings
    create_playbook(regular_playbook_attrs)
    sleep(1)
    add_regular_log
  end

  def create_context_playbook_loggings
    create_playbook(context_playbook_attrs)
    sleep(1)
    find('.btn-medium', :text => 'Log Task Done').click
    # click context row
    sleep(1)
    find('span', :text => 'Anger [circumstance]').click
    all('.amount').first.click
    all('.amount').first.set(1)
    all('.amount').last.click
    all('.amount').last.set(1)
    all('.save').first.click
  end

  def add_regular_log
    find('.btn-medium', :text => 'Log Task Done').click
    find('.amount').click
    find('.amount').set(1)
    all('.save').first.click
    sleep 5
  end

  def check_regular_playbook_loggings
    page.has_field?('.amount', :with => '1')
  end

  def check_context_playbook_loggings
    # click context row
    find('span', :text => 'Anger [circumstance]').click
    page.has_field?('.amount', :with => '1')
  end

  def regular_playbook_attrs
    {name: 'Name', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4,  unit: '2'}, level_3: {unit: '3'}, more_setting: {active_period: {start_date: '1/1/2010', end_date: '1/1/2014'}}}
  end

  def context_playbook_attrs
    {name: 'Name', of_type: 'Context', trigger: 'Anger', checkin_period: '3'}
  end
  
  def reset_playbook_created_date
     plan = NewPlan.first
     plan.created_at = Date.today - 4.days
     plan.save
  end

end
