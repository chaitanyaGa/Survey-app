require 'spec_helper'


describe NewPlansController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe '#attachments' do
    let(:attachment) {Rack::Test::UploadedFile.new('./spec/support/human_big.png','image/jpg')}

    it 'create attachment' do
      json = { :application => { :name => 'foo', :description => 'bar' } }
      request.env['CONTENT_TYPE'] = 'application/json'
      request.env['RAW_POST_DATA'] = json
      Attachment.destroy_all
      xhr :post, :add_attachment, {files: [attachment], temporary_id: '12345'}
      Attachment.count.should be(1)
      Attachment.last.parent.should be(nil)
      response.code.should == '200'

      Attachment.destroy_all
      new_plan = @user.new_plans.create!( {'name'=>'dd', 'of_type'=>'Regular', 'script'=>'', 'reported'=>true, 'checkin_times'=>'1', 'checkin_period'=>'year', 'importance'=>'5', 'starttime'=>'08/31/2004', 'endtime'=>'08/31/2024', 'active'=>true, 'is_negative'=>false, 'active_period'=>false, 'set_reminder'=>false, 'checkin_same_as_task'=>false, 'periodicities_attributes'=>[{'unit'=>'days', 'magnitude'=>'1', 'level'=>1}, {'unit'=>'week', 'magnitude'=>'1', 'level'=>2}]})
      xhr :post, :add_attachment, files: [attachment], temporary_id: new_plan.id
      Attachment.count.should be(1)
      expect(new_plan.attachments.count).to eq(1)
      Attachment.last.parent_id.should be(new_plan.id)
      response.code.should == "200"
    end

    it 'delete attachments' do
      Attachment.destroy_all
      new_plan = @user.new_plans.create!( {'name'=>'dd', 'of_type'=>'Regular', 'script'=>'', 'reported'=>true, 'checkin_times'=>'1', 'checkin_period'=>'year', 'importance'=>'5', 'starttime'=>'08/31/2004', 'endtime'=>'08/31/2024', 'active'=>true, 'is_negative'=>false, 'active_period'=>false, 'set_reminder'=>false, 'checkin_same_as_task'=>false, 'periodicities_attributes'=>[{'unit'=>'days', 'magnitude'=>'1', 'level'=>1}, {'unit'=>'week', 'magnitude'=>'1', 'level'=>2}]})
      attachment = new_plan.attachments.new
      attachment.attachment_file_name = 'missing'
      attachment.save!
      xhr :delete, :delete_attachment, id: attachment.id
      Attachment.count.should be(0)
      response.code.should == "200"
    end
  end
end
