require 'spec_helper'

describe MapsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @tag = MapItemTag.create!({:name => 'Tag X' })
    @circumstance = MapItemType.find_by_identifier("circumstance")
    @thought = MapItemType.find_by_identifier("thought")
    @behavior = MapItemType.find_by_identifier("behavior")
    @emotion = MapItemType.find_by_identifier("emotion")
    @need = MapItemType.find_by_identifier("need")
    sign_in @user
  end

  def valid_attributes
    { title: 'B.E.N.T. test map' }
  end

  describe "GET tags" do
    it "returns json collection of tags" do
      map = @user.maps.create! valid_attributes
      tag = MapItemTag.create!({:name => 'Tag 1' })
      map.map_items.create!(:map_item_tag_id => tag.id, :map_item_type_id => @behavior.id)
      get :tags, :identifier => @behavior.identifier, :format => :json
      response.body.should == [tag].to_json
      response.should be_success

    end
  end

  describe "GET index" do
    it "returns json collection of maps" do
      map = @user.maps.create! valid_attributes
      get :index, :format => :json
      response.body.should == [map].to_json
      response.should be_success

    end
  end

  describe "DELETE destroy" do
    it "deletes requested map" do
      map = @user.maps.create! valid_attributes
      expect {
        delete :destroy, :id => map.to_param, :format => :json
      }.to change(Map, :count).by(-1)
      response.should be_success
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Map" do
        expect {
          post :create, :map => valid_attributes, :format => :json
        }.to change(Map, :count).by(1)
      end

      it "respons with anewly created map" do
        post :create, :map => valid_attributes, :format => :json
        response.body.should_not == nil
      end
    end

    describe "with invalid params" do
      it "responds with newly created but unsaved map" do
        # Trigger the behavior that occurs when invalid params are submitted
        Map.any_instance.stub(:save).and_return(false)
        post :create, {:map => {}}, :format => :json
        response.body['id'].should == nil
      end
    end
  end

  describe "PUT emotions" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @emotion_data = {"A" => {:emotion_type_id=> EmotionType.default[:id], :intensity=>1}, "B" => {:emotion_type_id=> EmotionType.default[:id], :intensity=>1}, "C" => {:emotion_type_id=> EmotionType.default[:id], :intensity=>1}}
    end

    describe "with valid params" do

      it "creates emotions" do
        put :emotion, :emotion_data => @emotion_data, :id => @map.id, :format => :json
        @map.reload

        @map.emotion_data.should == @emotion_data
        response.body.should_not == nil
        response.should be_success
      end

      it "updates emotions" do
        put :emotion, :emotion_data => @emotion_data, :id => @map.id, :format => :json
        @map.reload

        @map.emotion_data.should == @emotion_data
        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT thoughts" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @thought_data = {"A" => {:thinking_styles=>[], :underlying_beliefs=>[]}, "B" => {:thinking_styles=>[], :underlying_beliefs=>[]}, "C" => {:thinking_styles=>[], :underlying_beliefs=>[]} }
    end

    describe "with valid params" do

      it "creates thoughts" do
        put :thought, :thought_data => @thought_data, :id => @map.id, :format => :json
        @map.reload

        @map.thought_data.should == @thought_data
        response.body.should_not == nil
        response.should be_success
      end

      it "updates thoughts" do
        put :thought, :thought_data => @thought_data, :id => @map.id, :format => :json
        @map.reload

        @map.thought_data.should == @thought_data
        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT behaviors" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @behavior_data = {"A" => {:labels=>[]}, "B" => {:labels=>[]}, "C" => {:labels=>[]}}
    end

    describe "with valid params" do

      it "creates behaviors" do
        put :behavior, behavior_data: @behavior_data, :id => @map.id, :format => :json
        @map.reload

        @map.behavior_data.should == @behavior_data
        response.body.should_not == nil
        response.should be_success
      end

      it "updates behaviors" do

        put :behavior, behavior_data: @behavior_data, :id => @map.id, :format => :json
        @map.reload

        @map.behavior_data.should == @behavior_data
        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT needs" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @need_data = {"A" => {:needs=>["1"]}, "B" => {:needs=>[]}, "C" => {:needs=>[]}}
    end

    describe "with valid params" do

      it "creates needs" do
        put :need, :need_data => @need_data, :id => @map.id, :format => :json
        @map.reload

        @map.need_data.should == @need_data
        response.body.should_not == nil
        response.should be_success
      end

      it "updates needs" do
        put :need, :need_data => @need_data, :id => @map.id, :format => :json
        @map.reload

        @map.need_data.should == @need_data
        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT circumstances" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      types = CircumstanceType.fetch
      @where = types.detect{|t| t[:name] == "Where"}[:id]
      @when = types.detect{|t| t[:name] == "When"}[:id]
      @data = {"A" => {:circumstance_type_id=>nil}, "B" => {:circumstance_type_id=>@where}, "C" => {:circumstance_type_id=>@when}}
    end

    describe "with valid params" do

      it "creates circumstances" do
        put :circumstance, circumstance_data: @data, :id => @map.id, :format => :json
        @map.reload
        
        @map.circumstance_data.should == @data

        response.body.should_not == nil
        response.should be_success
      end

      it "updates circumstances" do
        data = {"A" => {:circumstance_type_id=>nil}, "B" => {:circumstance_type_id=>@when}, "C" => {:circumstance_type_id=>nil}}
        
        put :circumstance, circumstance_data: data, :id => @map.id, :format => :json
        @map.reload

        @map.circumstance_data.should == data

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

end 
