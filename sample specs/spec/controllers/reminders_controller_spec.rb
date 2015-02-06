require 'spec_helper'

describe RemindersController do

  def valid_attributes
    {name: "reminder", action_type: "Entry", action_id: "", action_name:"", active: true, existing_plan: false, reminder_times_attributes: [{id: "", time: "08:00 PM +0530 (Chennai)", formatted_time: "08:00 PM +0530 (Chennai)", repeat: false, enabled: true, _destroy: "false", days_of_week: ["Wed"]}]}
  end

  describe "Save Reminder" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should save timezone" do
      expect {
        post :create, :reminder => valid_attributes, :format => :json
      }.to change(Reminder, :count).by(1)
      ReminderTime.last.time_zone == 'Chennai'
      response.should be_success
    end
  end

end
