require 'spec_helper'

describe NewPlansController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  context 'Playbook Loggings' do
    it 'should assign 1 point when regular playbook highest periodicity is 1 day and done amount >= 20%' do
      create_and_check_regular_playbook_logging('day', 1, 1, 1)
    end

    it 'should assign 1 point when context playbook logging frequency is 1 day and done amount >= 20%' do
      create_and_check_context_playbook_logging('day', 1, 1, 51)
    end

    it 'should assign 2 points when regular playbook highest periodicity is 1 day and done amount >= 40%' do
      create_and_check_regular_playbook_logging('day', 2, 2, 2)
    end

    it 'should assign 2 points when context playbook logging frequency is 1 day and done amount >= 40%' do
      create_and_check_context_playbook_logging('day', 2, 2, 52)
    end

    it 'should assign 3 points when regular playbook highest periodicity is 1 day and done amount >= 60%' do
      create_and_check_regular_playbook_logging('day', 3, 3, 3)
    end

    it 'should assign 3 points when context playbook logging frequency is 1 day and done amount >= 60%' do
      create_and_check_context_playbook_logging('day', 3, 3, 53)
    end

    it 'should assign 4 points when regular playbook highest periodicity is 1 day and done amount >= 80%' do
      create_and_check_regular_playbook_logging('day', 4, 4, 4)
    end

    it 'should assign 4 points when context playbook logging frequency is 1 day and done amount >= 80%' do
      create_and_check_context_playbook_logging('day', 4, 4, 54)
    end

    it 'should assign 5 points when regular playbook highest periodicity is 1 day and done amount >= 100%' do
      create_and_check_regular_playbook_logging('day', 5, 5, 5)
    end

    it 'should assign 5 points when context playbook logging frequency is 1 day and done amount >= 100%' do
      create_and_check_context_playbook_logging('day', 5, 5, 55)
    end

    it 'should assign 5 points when regular playbook highest periodicity is 1 week and done amount >= 20%' do
      create_and_check_regular_playbook_logging('week', 1, 5, 5)
    end

    it 'should assign 5 points when context playbook logging frequency is 1 week and done amount >= 20%' do
      create_and_check_context_playbook_logging('week', 1, 5, 25)
    end

    it 'should assign 10 points when regular playbook highest periodicity is 1 week and done amount >= 40%' do
      create_and_check_regular_playbook_logging('week', 2, 10, 10)
    end

    it 'should assign 10 points when context playbook logging frequency is 1 week and done amount >= 40%' do
      create_and_check_context_playbook_logging('week', 2, 10, 30)
    end

    it 'should assign 15 points when regular playbook highest periodicity is 1 week and done amount >= 60%' do
      create_and_check_regular_playbook_logging('week', 3, 15, 15)
    end

    it 'should assign 15 points when context playbook logging frequency is 1 week and done amount >= 60%' do
      create_and_check_context_playbook_logging('week', 3, 15, 35)
    end

    it 'should assign 20 points when regular playbook highest periodicity is 1 week and done amount >= 80%' do
      create_and_check_regular_playbook_logging('week', 4, 20, 20)
    end

    it 'should assign 20 points when context playbook logging frequency is 1 week and done amount >= 80%' do
      create_and_check_context_playbook_logging('week', 4, 20, 40)
    end

    it 'should assign 25 points when regular playbook highest periodicity is 1 week and done amount >= 100%' do
      create_and_check_regular_playbook_logging('week', 5, 25, 25)
    end

    it 'should assign 25 points when context playbook logging frequency is 1 week and done amount >= 100%' do
      create_and_check_context_playbook_logging('week', 5, 25, 45)
    end

    def create_and_check_regular_playbook_logging(highest_periodicity, done_amount, points, total_points)
      create_regular_playbook(highest_periodicity)
      playbook = NewPlan.first
      loggings_param = regular_loggings_param
      loggings_param["new_plan_tasks_attributes"][0]["done_amount"] = done_amount
      create_playbook_loggings(playbook, loggings_param)
      check_loggings_points(points, total_points)
    end

    def create_and_check_context_playbook_logging(highest_periodicity, done_amount, points, total_points)
      create_context_playbook(highest_periodicity)
      playbook = NewPlan.first
      loggings_param = context_loggings_param(playbook.new_plan_items.first.entry_item_tag_id)
      new_plan_item_id = playbook.new_plan_items.first.id
      loggings_param["new_plan_tasks_attributes"][0]["done_amount"] = done_amount
      loggings_param["new_plan_tasks_attributes"][0].merge!(new_plan_item_id: new_plan_item_id)

      create_playbook_loggings(playbook, loggings_param)
      check_loggings_points(points, total_points)
    end

    def check_loggings_points(no_of_points, total_points)
      @user.reload.points.should == total_points # Total points
      @user.points(category: "Playbook Log").should == no_of_points # Episode points
      response.should be_success
    end

    def create_regular_playbook(highest_periodicity)
      param = playbook_params
      param.merge!(periodicity_attribute(highest_periodicity))
      create_playbook(param)
    end

    def create_context_playbook(highest_periodicity)
      create_playbook(context_playbook_params(highest_periodicity))
    end

    def create_playbook(param)
      expect {
        post :create, :new_plan => param, :format => :json
      }.to change(NewPlan, :count).by(1)
    end

    def create_playbook_loggings(playbook, param)
      expect {
        put :update, :id => playbook.id, :new_plan => param, :format => :json
      }.to change(NewPlanTask, :count).by(1)
    end

    def regular_loggings_param
      {
        "new_plan_tasks_attributes"=>[{"context_amount"=>0, 
                                       "done_amount"=>"1", 
                                       "begin_timestamp"=>"15/09/2014", 
                                       "id"=>""} 
                                    ]
      }
    end

    def context_loggings_param(entry_item_id)
      {
        "new_plan_tasks_attributes"=>[{
                                       "entry_item_tag_id"=>entry_item_id,
                                       "context_amount"=>5, 
                                       "done_amount"=>"1", 
                                       "begin_timestamp"=>"15/09/2014", 
                                       "id"=>""} 
                                    ]
      }
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
    
    def periodicity_attribute(highest_periodicity)
      {
      "periodicities_attributes"=>[{
        "id"=>"", 
        "unit"=>"times", 
        "magnitude"=>"5", 
        "level"=>1
      }, 
      {"id"=>"", 
       "unit"=>highest_periodicity, 
       "magnitude"=>"1", 
       "level"=>2}
      ]
      }
    end
    
    def context_playbook_params(highest_periodicity)
      {
        "name"=>"context_playbook", 
        "of_type"=>"Context", 
        "script"=>"", 
        "reported"=>true, 
        "checkin_times"=>"1", 
        "checkin_period"=>highest_periodicity, 
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
