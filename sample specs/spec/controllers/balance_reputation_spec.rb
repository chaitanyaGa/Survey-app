require 'spec_helper'

describe BalancesController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Default balance means balace which has less than 5 answer
  # No points are given to users for default balance creation
  # Non-default balance means episode which has more than 5 answer
  # Points are given to users for non-default balance creation
  context 'Balance' do
    it 'should assign 100 points and Cognizant badge on first non-default balance creation' do
      create_balance(balance_params)
      
      # check user points and badges
      check_balance_points_and_badges(100, ['Cognizant'])
    end

    it 'should delete points and batches for balance if non-default balance is deleted' do
      create_balance(balance_params)
      check_balance_points_and_badges(100, ['Cognizant'])
      
      delete_balance(Balance.first)
      
      # check user points and badges
      check_balance_points_and_badges(0, [])
    end

    it 'should assign badge Cognizant but not assign points for default balance creation' do
      create_balance(default_params)
      
      # check user points and badges
      check_balance_points_and_badges(0, ['Cognizant'])
    end

    it 'should not delete points but delete batches for balance if default balance is deleted' do
      create_balance(default_params)
      check_balance_points_and_badges(0, ['Cognizant'])
      
      delete_balance(Balance.first)
      
      # check user points and badges
      check_balance_points_and_badges(0, [])
    end

    it 'should not assign more than 200 points for non-default balance created on same day' do
      # Balance 1
      create_balance(balance_params)

      # Balance 2
      param = balance_params
      param["tag"] = "test_balance_2"
      create_balance(param)
      
      # Balance 3
      param = balance_params
      param["tag"] = "test_balance_3"
      create_balance(param)
      
      # check user points and badges
      check_balance_points_and_badges(200, ['Cognizant'])
    end
   
    it 'should delete points if non-default balance is updated to default balance' do
      create_balance(balance_params)
      
      check_balance_points_and_badges(100, ['Cognizant'])

      update_balance(Balance.first, default_params)
      
      # delete only points , not badge
      check_balance_points_and_badges(0, ['Cognizant'])
    end

    it 'should add points if default balance is updated to non-default balance' do
      create_balance(default_params)
      
      check_balance_points_and_badges(0, ['Cognizant'])

      update_balance(Balance.first, balance_params)
      
      # add points , badges remains same
      check_balance_points_and_badges(100, ['Cognizant'])
    end
    
    it 'should add 300 points for two non-default balance created on different days' do
      create_older_balance

      check_balance_points_and_badges(100, ['Cognizant'])

      # create 2nd balance
      param = balance_params
      param["tag"] = "test_balance_3"
      create_balance(param)

      check_balance_points_and_badges(200, ['Cognizant'])
      
      # create 3rd balance
      param = balance_params
      param["tag"] = "test_balance_4"
      create_balance(param)

      check_balance_points_and_badges(300, ['Cognizant'])
    end

    it 'should not delete points if one non-default Balance is deleted but another non-default episode present for the same day' do
      # Balance 1
      create_balance(balance_params)

      # Balance 2
      param = balance_params
      param["tag"] = "test_balance_3"
      create_balance(param)
      
      # Balance 3
      param = balance_params
      param["tag"] = "test_balance_4"
      create_balance(param)
      
      # check user points and badges
      check_balance_points_and_badges(200, ['Cognizant'])
     
      # delete first balance
      delete_balance(Balance.first)

      check_balance_points_and_badges(200, ['Cognizant'])

    end

    def create_older_balance
      create_balance(default_params)
      
      check_balance_points_and_badges(0, ['Cognizant'])
      
      # change created_at of episode
      balance = Balance.first
      balance.created_at = Date.today - 2.day
      balance.save!
      
      update_balance(balance, balance_params)
    end

    def create_balance(params)
      expect {
        post :create, :balance => params, :format => :json
      }.to change(Balance, :count).by(1)
    end

    def update_balance(balance, params)
      expect {
        put :update, :id => balance.id, :balance => params, :format => :json
      }.to change(Balance, :count).by(0)
    end

    def delete_balance(balance)
      expect{
        delete :destroy, :id => balance.id, :format => :json
      }.to change(Balance, :count).by(-1)
    end

    def check_balance_points_and_badges(no_of_points, badges)
      @user.reload.points.should == no_of_points # Total points
      @user.points(category: 'Balance').should == no_of_points # Episode points
      @user.bronze_badges.collect(&:name).should == badges
      response.should be_success
    end

    def balance_params
      {"entry_item_type_id"=>EntryItemType.find_by_name('Emotions').id, 
       "examples"=>"", 
       "tag"=>"test_balance", 
       "true_false"=>false, 
       "true_false_new"=>false, 
       "items"=>[{"section"=>"default", 
                  "question_id"=>"main_reason", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>["answer1"], 
                  "level"=>1, 
                  "normal_reframe"=>true}, 
                {"section"=>"default", 
                  "question_id"=>"what_changes", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>[""]}, 
                {"section"=>"default", 
                  "question_id"=>"believe_yes", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Behaviors').id, 
                  "tags"=>["answer2"], 
                  "yes_no"=>true}, 
                {"section"=>"default", 
                  "question_id"=>"believe_no", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Behaviors').id, 
                  "tags"=>["answer3"], 
                  "yes_no"=>false}, 
                {"section"=>"default", 
                  "question_id"=>"belief_reframe", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Beliefs').id,
                  "tags"=>["answer4"], 
                  "normal_reframe"=>false}, 
                {"section"=>"playbook", 
                  "question_id"=>"this_triggers", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>[""], 
                  "normal_reframe"=>false}, 
                {"section"=>"playbook", 
                  "question_id"=>"what_actions", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Actions').id, 
                  "tags"=>["answer5"]}
              ]}
    end

    def default_params
      {"entry_item_type_id"=>EntryItemType.find_by_name('Emotions').id, 
       "examples"=>"", 
       "tag"=>"test_balance_2", 
       "true_false"=>false, 
       "true_false_new"=>false, 
       "items"=>[{"section"=>"default", 
                  "question_id"=>"main_reason", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>[""], 
                  "level"=>1, 
                  "normal_reframe"=>true}, 
                {"section"=>"default", 
                  "question_id"=>"what_changes", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>[""]}, 
                {"section"=>"default", 
                  "question_id"=>"believe_yes", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Behaviors').id, 
                  "tags"=>[""], 
                  "yes_no"=>true}, 
                {"section"=>"default", 
                  "question_id"=>"believe_no", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Behaviors').id, 
                  "tags"=>[""], 
                  "yes_no"=>false}, 
                {"section"=>"default", 
                  "question_id"=>"belief_reframe", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Beliefs').id,
                  "tags"=>[""], 
                  "normal_reframe"=>false}, 
                {"section"=>"playbook", 
                  "question_id"=>"this_triggers", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('What').id, 
                  "tags"=>[""], 
                  "normal_reframe"=>false}, 
                {"section"=>"playbook", 
                  "question_id"=>"what_actions", 
                  "entry_item_type_id"=>EntryItemType.find_by_name('Actions').id, 
                  "tags"=>[""]}
              ]}
    end

  end
end
