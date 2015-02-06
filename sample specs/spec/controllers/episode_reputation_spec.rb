require 'spec_helper'

describe EntriesController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Default episode means episode which has "Misc." what tag and all entry rating level is 4
  # No points are given to users for default episode creation
  # Non-default episode means episode which has what tag not equal to "Misc." and any one of
  # entry rating level is not equal to 4
  # Points are given to users for non-default episode creation
  context 'Episode' do
    it 'should assign 10 points and Escribitionist badge on first non-default episode creation' do
      create_episode(entry_params)
      
      # check user points and badges
      check_episode_points_and_badges(10, ['Escribitionist'])
    end

    it 'should delete points and batches for episode if non-default episode is deleted' do
      create_episode(entry_params)
      check_episode_points_and_badges(10, ['Escribitionist'])
      
      delete_episode(Entry.first)
      
      # check user points and badges
      check_episode_points_and_badges(0, [])
    end

    it 'should assign badge Escribitionist but not assign points for default episode creation' do
      create_episode(default_params)
      
      # check user points and badges
      check_episode_points_and_badges(0, ['Escribitionist'])
    end

    it 'should not delete points but delete batches for episode if default episode is deleted' do
      create_episode(default_params)
      check_episode_points_and_badges(0, ['Escribitionist'])
      
      delete_episode(Entry.first)
      
      # check user points and badges
      check_episode_points_and_badges(0, [])
    end

    it 'should not assign more than 10 points for non-default episodes created on same day' do
      # Episode 1
      create_episode(entry_params)

      # Episode 2
      create_episode(entry_params)
      
      # check user points and badges
      check_episode_points_and_badges(10, ['Escribitionist'])
    end
   
    it 'should delete points if non-default episode is updated to default episode' do
      create_episode(entry_params)
      
      check_episode_points_and_badges(10, ['Escribitionist'])

      update_episode(Entry.first, default_params)
      
      # delete only points , not badge
      check_episode_points_and_badges(0, ['Escribitionist'])
    end

    it 'should add points if default episode is updated to non-default episode' do
      create_episode(default_params)
      
      check_episode_points_and_badges(0, ['Escribitionist'])

      update_episode(Entry.first, entry_params)
      
      # add points , badges remains same
      check_episode_points_and_badges(10, ['Escribitionist'])
    end
    
    it 'should add 20 points for two non-default episode created on different days' do
      create_older_episode

      check_episode_points_and_badges(10, ['Escribitionist'])

      # create 2nd episode
      create_episode(entry_params)

      check_episode_points_and_badges(20, ['Escribitionist'])
    end

    it 'should not delete points if one non-default episode is deleted but another non-default episode present for the same day' do
      # Episode 1
      create_episode(entry_params)

      # Episode 2
      create_episode(entry_params)
      
      # check user points and badges
      check_episode_points_and_badges(10, ['Escribitionist'])
     
      # delete first episode
      delete_episode(Entry.first)

      check_episode_points_and_badges(10, ['Escribitionist'])

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

    def create_episode(params)
      expect {
        post :create, :items => params[:items], :tag_types => params[:tag_types], :ratings => params[:ratings], :entry => params[:entry], :format => :json
      }.to change(Entry, :count).by(1)
    end

    def update_episode(entry, params)
      expect {
        put :update, :id => entry.id, :items => params[:items], :tag_types => params[:tag_types], :ratings => params[:ratings], :entry => params[:entry], :format => :json
      }.to change(Entry, :count).by(0)
    end

    def delete_episode(entry)
      expect{
        delete :destroy, :id => entry.id, :format => :json
      }.to change(Entry, :count).by(-1)
    end

    def check_episode_points_and_badges(no_of_points, badges)
      @user.reload.points.should == no_of_points # Total points
      @user.points(category: 'Episode').should == no_of_points # Episode points
      @user.bronze_badges.collect(&:name).should == badges
      response.should be_success
    end

    def entry_params
      {
        :items =>{"what"=>["anil"]}, 
        :tag_types =>{"what"=>["1"]}, 
        :ratings =>{"rating_level"=>4, 
                    "intention_level"=>5, 
                    "joy_level"=>6, 
                    "energy_level"=>7, 
                    "creative_level"=>4, 
                    "empathy_level"=>4}, 
        :entry =>{"begin_at"=>"09/11/2012 02:00 PM", 
                  "end_at"=>"09/11/2015 05:00 PM"}
      }
    end

    def default_params
      {
        :items =>{"what"=>["Misc."]}, 
        :tag_types =>{"what"=>["1"]}, 
        :ratings =>{"rating_level"=>4, 
                    "intention_level"=>4, 
                    "joy_level"=>4, 
                    "energy_level"=>4, 
                    "creative_level"=>4, 
                    "empathy_level"=>4}, 
        :entry =>{"begin_at"=>"09/11/2012 02:00 PM", 
                  "end_at"=>"09/11/2015 05:00 PM"}
      }
    end

  end
end
