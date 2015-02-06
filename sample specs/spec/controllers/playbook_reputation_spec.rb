require 'spec_helper'

describe NewPlansController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  context 'Playbook' do
    it 'should assign 50 points and Playbooker badge on first playbook creation with a reminder and with highest periodicity of day' do
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(50, ['Playbooker'])
    end

    it 'should assign 50 points and Playbooker badge on first context playbook creation and logging frequency of day' do
      create_playbook(context_playbook_params)
      
      # check user points and badges
      check_playbook_points_and_badges(50, ['Playbooker'])
    end

    it 'should assign 20 points and Playbooker badge on first playbook creation with a reminder and with highest periodicity of week' do
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_week)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(20, ['Playbooker'])
    end

    it 'should assign 20 points and Playbooker badge on first context playbook creation and logging frequency of week' do
      param = context_playbook_params
      param['checkin_period'] = 'week'
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(20, ['Playbooker'])
    end

    it 'should delete points and batches for playbook if playbook is deleted' do
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
      check_playbook_points_and_badges(50, ['Playbooker'])
      
      delete_playbook(NewPlan.first)
      
      # check user points and badges
      check_playbook_points_and_badges(0, [])
    end

    it 'should assign badge Playbooker but not assign points for playbook creation without reminder' do
      param = playbook_params
      param['set_reminder'] = false
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(0, ['Playbooker'])
    end

    it 'should not delete points but delete batches for playbook if playbook without reminder is deleted and no other playbook present' do
      param = playbook_params
      param['set_reminder'] = false
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(0, ['Playbooker'])
      
      delete_playbook(NewPlan.first)
      
      # check user points and badges
      check_playbook_points_and_badges(0, [])
    end

    it 'should not assign more than 1000 points for playbook' do
      create_20_playbook
      # Assign 1000 points for 20 playbook
      check_playbook_points_and_badges(1000, ['Playbooker'])

      # add playbook
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)

      # should not add points for this playbook
      check_playbook_points_and_badges(1000, ['Playbooker'])
    end

    it 'should delete points if reminder is deleted from playbook' do
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)

      check_playbook_points_and_badges(50, ['Playbooker'])

      param = playbook_params
      param['set_reminder'] = false
      playbook = NewPlan.first

      param.merge!(playbook_periodicity_attribute(playbook, 'day'))
      param.merge!(delete_reminder_attribute(playbook))

      update_playbook(playbook, param)

      # delete only points , not badge
      check_playbook_points_and_badges(0, ['Playbooker'])
    end

    it 'should add points if reminder is added to playbook' do
      param = playbook_params
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
     
      # playbook without reminder
      check_playbook_points_and_badges(0, ['Playbooker'])
      
      param = playbook_params
      playbook = NewPlan.first

      param.merge!(playbook_periodicity_attribute(playbook, 'day'))
      param.merge!(reminder_attributes)

      update_playbook(playbook, param)
      
      # playbook with reminder
      check_playbook_points_and_badges(50, ['Playbooker'])
    end

    # Case
    # 21 Playbook exists with 1000 point for first 20 episode
    # if first playbook deleted then donot delete point, points remains 1000
    it 'should not delete points if playbook is deleted after max point reached for playbook and other playbook exist' do
      create_20_playbook

      # add playbook
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)

      check_playbook_points_and_badges(1000, ['Playbooker'])
      
      delete_playbook(NewPlan.first)
      
      check_playbook_points_and_badges(1000, ['Playbooker'])
    end

    it 'should decrease 30 points when regular playbook periodicity is changed from day to week' do
      # create playbook with periodicity of day
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_day)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(50, ['Playbooker'])

      param = playbook_params
      playbook = NewPlan.first

      param.merge!(reminder_attributes) 
      param.merge!(playbook_periodicity_attribute(playbook, 'week'))

      update_playbook(playbook, param)
      
      # playbook with reminder
      check_playbook_points_and_badges(20, ['Playbooker'])
    end

    it 'should increase 30 points when regular playbook periodicity is changed from week to day' do
      # create playbook with periodicity of day
      param = playbook_params
      param.merge!(reminder_attributes)
      param.merge!(periodicity_attribute_highest_week)
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(20, ['Playbooker'])

      param = playbook_params
      playbook = NewPlan.first

      param.merge!(reminder_attributes) 
      param.merge!(playbook_periodicity_attribute(playbook, 'day'))

      update_playbook(playbook, param)
      
      # playbook with reminder
      check_playbook_points_and_badges(50, ['Playbooker'])
    end

    it 'should add 30 points when context playbook logging frequency is changed from week to day' do
      param = context_playbook_params
      param['checkin_period'] = 'week'
      create_playbook(param)
      
      # check user points and badges
      check_playbook_points_and_badges(20, ['Playbooker'])

      playbook = NewPlan.first
      update_playbook(playbook, context_playbook_params)

      # check user points and badges
      check_playbook_points_and_badges(50, ['Playbooker'])
    end

    it 'should decrease 30 points when context playbook logging frequency is changed from day to week' do
      create_playbook(context_playbook_params)
      # check user points and badges
      check_playbook_points_and_badges(50, ['Playbooker'])

      playbook = NewPlan.first
      param = context_playbook_params
      param['checkin_period'] = 'week'
      update_playbook(playbook, param)

      # check user points and badges
      check_playbook_points_and_badges(20, ['Playbooker'])
    end

    def create_20_playbook
      (1..20).each do |num|
        param = playbook_params
        param['name'] = "test_#{num}"
        param.merge!(reminder_attributes)
        param.merge!(periodicity_attribute_highest_day)
        create_playbook(param)
        check_playbook_points_and_badges((50 * num), ['Playbooker'])
      end
    end

    def create_older_episode
      create_episode(default_params)

      check_episode_points_and_badges(0, ['Escribitionist'])

      # change created_at of episode
      entry = Entry.first
      entry.created_at = Date.today - 2.day
      entry.save!

      update_episode(entry, entry_params)
    end

    def create_playbook(params)
      expect {
        post :create, :new_plan => params, :format => :json
      }.to change(NewPlan, :count).by(1)
    end

    def update_playbook(playbook, params)
      expect {
        put :update, :id => playbook.id, :new_plan => params, :format => :json
      }.to change(NewPlan, :count).by(0)
    end

    def delete_playbook(playbook)
      expect{
        delete :destroy, :id => playbook.id, :format => :json
      }.to change(NewPlan, :count).by(-1)
    end

    def check_playbook_points_and_badges(no_of_points, badges)
      @user.reload.points.should == no_of_points # Total points
      @user.points(category: 'Playbook').should == no_of_points # Episode points
      @user.bronze_badges.collect(&:name).should == badges
      response.should be_success
    end

    def playbook_params
      {"name"=>"test", 
        "of_type"=>"Regular", 
        "script"=>"", 
        "reported"=>true, 
        "checkin_times"=>"1", 
        "checkin_period"=>"day", 
        "importance"=>"5", 
        "starttime"=>"09/14/2004", 
        "endtime"=>"09/14/2024", 
        "active"=>true, 
        "is_negative"=>false, 
        "active_period"=>false, 
        "set_reminder"=>true, 
        "checkin_same_as_task"=>false, 
        "temporary_id"=>"1410702397613", 
      }
    end

    def periodicity_attribute_highest_week
      {
        "periodicities_attributes"=>[{
        "id"=>"", 
        "unit"=>"times", 
        "magnitude"=>"1", 
        "level"=>1
      }, 
      {"id"=>"", 
       "unit"=>"week", 
       "magnitude"=>"1", 
       "level"=>2}]
      }
    end

    def periodicity_attribute_highest_day
      {
      "periodicities_attributes"=>[{
        "id"=>"", 
        "unit"=>"times", 
        "magnitude"=>"1", 
        "level"=>1
      }, 
      {"id"=>"", 
       "unit"=>"day", 
       "magnitude"=>"1", 
       "level"=>2}
      ]
      }
    end

    def playbook_periodicity_attribute(playbook, highest_period)
      {
      "periodicities_attributes"=>[{
        "id"=> playbook.periodicities.first.id, 
        "unit"=>"times", 
        "magnitude"=>"1", 
        "level"=>1
      }, 
      {"id"=> playbook.periodicities.second.id, 
       "unit"=> highest_period, 
       "magnitude"=>"1", 
       "level"=>2}
      ]
      }
    end

    def reminder_attributes
      {
      "reminder_attributes"=>{
        "id"=>"", 
        "name"=>"test", 
        "action_id"=>"", 
        "action_name"=>"test", 
        "active"=>true, 
        "existing_plan"=>false, 
        "reminder_times_attributes"=>[{
          "id"=>"", 
          "time"=>"07:30 PM +0530 (Chennai)", 
          "formatted_time"=>"07:30 PM +0530 (Chennai)", 
          "repeat"=>false, 
          "enabled"=>true, 
          "_destroy"=>"false", 
          "days_of_week"=>["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        }]
      }
      }
    end

    def delete_reminder_attribute(playbook)
      {
        "reminder_attributes" => {
          "id" => playbook.reminder.id,
          "_destroy" => true
        }
      }
    end
    def context_playbook_params
      {
        "name"=>"context_playbook", 
        "of_type"=>"Context", 
        "script"=>"", 
        "reported"=>true, 
        "checkin_times"=>"1", 
        "checkin_period"=>"day", 
        "importance"=>"5", 
        "starttime"=>"09/15/2004", 
        "endtime"=>"09/15/2024", 
        "active"=>true, 
        "is_negative"=>false, 
        "active_period"=>false, 
        "set_reminder"=>false, 
        "checkin_same_as_task"=>false, 
        "temporary_id"=>"1410779442731", 
        "new_plan_items_attributes"=>[{"name"=>"anger"}]
      } 
    end

  end
end
