require 'spec_helper'

  
describe NewPlan do
  
  it '#set_log_unit' do
    user = create(:user)
    @attrs = {
      'name'=>'name', 'of_type'=>'Regular', 'script'=>'', 'reported'=>true, 'checkin_times'=>'1', 'checkin_period'=>'day', 'importance'=>'5', 'starttime'=>'08/07/2004 12:34 PM', 'endtime'=>'08/07/2024 12:34 PM', 'active'=>true, 'is_negative'=>false, 'active_period'=>false, 'set_reminder'=>false, 'checkin_same_as_task'=>false, 'periodicities_attributes' => [{'id'=>'', 'unit'=>'times', 'magnitude'=>'1', 'level'=>'1'}, {'id'=>'', 'unit'=>'day', 'magnitude'=>'2', 'level'=>'2'}]}

    np = user.new_plans.new(@attrs)
    np.send(:set_log_unit)
    np.log_unit.should eq('day')

    @attrs['periodicities_attributes'] << {'id'=>'', 'unit'=>'week', 'magnitude'=>'1', 'level'=>'3', '_destroy'=>'false'}
    np = user.new_plans.new(@attrs)
    np.send(:set_log_unit)
    np.log_unit.should eq('day')


    @attrs['checkin_period'] = 'week'
    np = user.new_plans.new(@attrs)
    np.send(:set_log_unit)
    np.log_unit.should eq('week')

    @attrs['checkin_period'] = 'year'
    @attrs['periodicities_attributes'][2]['unit'] = 'month'
    np = user.new_plans.new(@attrs)
    np.send(:set_log_unit)
    np.log_unit.should eq('month')
  end

  it 'mandatory fields check' do
    new_plan = NewPlan.new
    new_plan.valid?
    new_plan.errors['name'].should eq(["Name can't be blank"])
    new_plan.errors['checkin_times'].should eq(["Checkin times can't be blank"])
    new_plan.errors['checkin_period'].should eq(["Checkin period can't be blank"])
    new_plan.errors['of_type'].should eq(["Type can't be blank", "Playbook type is not valid"])
  end

  it 'mandatory fields if new_plan is of type regular' do
    new_plan = NewPlan.new(of_type: 'Regular')
    new_plan.valid?
    new_plan.errors['periodicities'].should eq(["Periodicity can't be empty"])
  end

  it 'mandatory fields if new_plan is of type context' do
    new_plan = NewPlan.new(of_type: 'Context')
    new_plan.valid?
    new_plan.errors['new_plan_items'].should eq(["Trigger can't be empty"])
  end

  it 'end date should not be greater than start date' do
    new_plan = NewPlan.new(starttime: '1/1/2001', endtime: '1/1/2000')
    new_plan.valid?
    new_plan.errors['endtime'].should eq(['End time should be greater than start time'])
  end

  context 'checkin_same_as_task' do
    it 'should set checkin_period and checkin_times if checkin_same_as_task is set to false' do
      new_plan = NewPlan.new(of_type: 'Regular', checkin_same_as_task: false, periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '1' }, {level: 2, unit: 'day', magnitude: '3' }, {level: 3, unit: 'week', magnitude: '4'}])
      new_plan.save
      new_plan.checkin_period.should eq('week')
      new_plan.checkin_times.should eq(1)
    end

    it 'shouldnt set checkin_period and checkin_times if checkin_same_as_task is set to true' do
      new_plan = NewPlan.new(of_type: 'Regular', checkin_same_as_task: true, periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '1' }, {level: 2, unit: 'day', magnitude: '3' }, {level: 3, unit: 'week', magnitude: '4'}], checkin_times: '5', checkin_period: 'week')
      new_plan.save
      new_plan.checkin_period.should eq('week')
      new_plan.checkin_times.should eq(5)
    end
  end

  it 'cannot remove third level periodicity if logs are added' do
  end

  context 'once logs are added' do
    before do
      @user = create(:user)
      @new_plan = @user.new_plans.new(name: 'Name', of_type: 'Regular', checkin_same_as_task: true, periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '1' }, {level: 2, unit: 'day', magnitude: '3' }], checkin_times: '5', checkin_period: 'week', importance: 5, starttime: "10/01/2004", endtime: "10/01/2024", active: true, is_negative: false, active_period: false)
      @new_plan.send(:set_log_unit)
      attrs =  {new_plan_tasks_attributes: [{context_amount: 0, done_amount: '2', begin_timestamp: '01/10/2014', new_plan_id: @new_plan.id}]}
      @new_plan.update_attributes attrs
    end

    it 'cannot update periodicity' do
      attrs = {periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '5', id: @new_plan.periodicities.first.id}], of_type: 'Regular'}
      @new_plan.save_update attrs
      @new_plan.errors['periodicity'].should eq(['You cannot change periodicty after adding logs for it!!'])
    end

    it 'cannot remove periodicities' do
      @new_plan.save_update({periodicities_attributes: [{'_destroy' => true, id: @new_plan.periodicities.last.id}]})
      @new_plan.errors[:new_plan].should eq(["You cannot delete periodicity after adding logs for it!!"])
    end

    it 'cannot update new_plan_items' do
      @new_plan = @user.new_plans.new.save_update({name: 'Context', of_type: 'Context', checkin_same_as_task: true, checkin_times: '5', checkin_period: 'week', importance: 5, starttime: "10/01/2004", endtime: "10/01/2024", active: true, is_negative: false, active_period: false, set_reminder: false, checkin_same_as_task: false, new_plan_items_attributes: [{name: "Misc. [Circumstance]"}]})
      item = @new_plan.new_plan_items.last
      attrs =  {new_plan_tasks_attributes: [{context_amount: '2', done_amount: '2', begin_timestamp: '01/10/2014', entry_item_tag_id: item.entry_item_tag_id, new_plan_item_id: item.id}]}
      @new_plan.save_update attrs
      attrs = {new_plan_items_attributes: [{name: "Trigger Changes [Circumstance]"}]}
      @new_plan.save_update attrs
      @new_plan.new_plan_items.size.should eq(1)
    end

    it 'cannot switch form regular to context' do
      @new_plan.save_update new_plan_items_attributes: [{name: "Misc. [Circumstance]"}], of_type: 'Context'
      @new_plan.errors['new_plan_items'].should eq(["Trigger can't be empty"])
    end

    it 'cannot switch form context to regular' do
      @new_plan = @user.new_plans.new({name: 'Context', of_type: 'Context', checkin_same_as_task: true, checkin_times: '5', checkin_period: 'week', importance: 5, starttime: "10/01/2004", endtime: "10/01/2024", active: true, is_negative: false, active_period: false, set_reminder: false, checkin_same_as_task: false, new_plan_items_attributes: [{name: "Misc. [Circumstance]"}]})
      @new_plan.send(:set_log_unit)
      item = @new_plan.new_plan_items.last
      attrs =  {new_plan_tasks_attributes: [{context_amount: '2', done_amount: '2', begin_timestamp: '01/10/2014', entry_item_tag_id: item.entry_item_tag_id, new_plan_item_id: item.id}]}
      @new_plan.save_update attrs
      attrs = {periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '1' }, {level: 2, unit: 'day', magnitude: '3' }], of_type: 'Regular'}
      @new_plan.save_update attrs
      @new_plan.errors[:periodicity].should eq(["You cannot change periodicty after adding logs for it!!"])
    end
  end

  it 'checkin_period unit cannot be lower than second highest periodicity unit' do
    new_plan = NewPlan.new(of_type: 'Regular', checkin_same_as_task: true, periodicities_attributes: [{level: 1, unit: 'hours', magnitude: '1' }, {level: 2, unit: 'month', magnitude: '3' }, {level: 3, unit: 'year', magnitude: '4'}], checkin_times: '5', checkin_period: 'day')
    new_plan.valid?
    new_plan.errors['checkin_period'].should eq(['Log frequency cannot be lower than month'])
  end

  it 'should raise error if duplicate tags are added' do
    new_plan = NewPlan.new(of_type: 'Regular', new_plan_items_attributes: [{name: 'Tags [Circumstance]'}, {name: 'Tags'}])
    new_plan.valid?
    new_plan.errors['tags'].should eq(['Please remove duplicate tags'])
  end
end
