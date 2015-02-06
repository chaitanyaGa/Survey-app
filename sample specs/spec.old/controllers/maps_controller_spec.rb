require 'spec_helper'

describe MapsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @tag = MapItemTag.create!({:name => 'Tag X' })
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
      map.map_items.create!(:map_item_tag_id => tag.id, :map_item_type_id => @behavior.id, :entry => "test behavior")
      get :tags, :format => :json
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
      @attributes = {emotion_entry: "emotions description", tags: ["A", "B", "AFRAID", "ANNOYED"]}
    end

    describe "with valid params" do

      it "creates emotions" do
        put :emotion, @attributes.merge(:id => @map.id, :format => :json)
        @map.reload

        @map.emotion_entry.should == @attributes[:emotion_entry]
        @map.emotions_ctags.should == ["A", "B"]
        @map.emotions_tags.should == ["A", "B", "AFRAID", "ANNOYED"]
        response.body.should_not == nil
        response.should be_success
      end

      it "updates emotions" do

        @map.map_items.create!(:map_item_tag_id => @tag.id, :map_item_type_id => @emotion.id, :entry => "test behavior")
        
        put :emotion, emotion_entry: "emotion update", tags: ["A", "B", "C"], id: @map.id, format: :json
        @map.reload

        @map.emotion_entry.should == "emotion update"
        @map.emotions_ctags.should == ["A", "B", "C"]
        @map.emotions_tags.should == ["A", "B", "C"]

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT thoughts" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @attributes = {thought_entry: "thoughts description", tags: ["A", "B", "I'm going to fail", "I don't belong"]}
    end

    describe "with valid params" do

      it "creates thoughts" do
        put :thought, @attributes.merge(:id => @map.id, :format => :json)
        @map.reload

        @map.thought_entry.should == @attributes[:thought_entry]
        @map.thoughts_ctags.should == ["A", "B"]
        @map.thoughts_tags.should == ["A", "B", "I'm going to fail", "I don't belong"]
        response.body.should_not == nil
        response.should be_success
      end

      it "updates thoughts" do
        @map.map_items.create!(:map_item_tag_id => @tag.id, :map_item_type_id => @thought.id, :entry => "test thought")

        put :thought, thought_entry: "thought update", tags: ["A", "B", "C"], id: @map.id, format: :json
        @map.reload

        @map.thought_entry.should == "thought update"
        @map.thoughts_ctags.should == ["A", "B", "C"]
        @map.thoughts_tags.should == ["A", "B", "C"]

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT behaviors" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @attributes = {behavior_entry: "behaviors description", tags: ["A", "B", "Abusive", "Abrassive"]}
    end

    describe "with valid params" do

      it "creates behaviors" do
        put :behavior, @attributes.merge(:id => @map.id, :format => :json)
        @map.reload

        @map.behavior_entry.should == @attributes[:behavior_entry]
        @map.behaviors_ctags.should == ["A", "B"]
        @map.behaviors_tags.should == ["A", "B", "Abusive", "Abrassive"]
        response.body.should_not == nil
        response.should be_success
      end

      it "updates behaviors" do
        @map.map_items.create!(:map_item_tag_id => @tag.id, :map_item_type_id => @behavior.id, :entry => "test behavior")

        put :behavior, behavior_entry: "", tags: ["A", "B", "C"], id: @map.id, format: :json
        @map.reload

        @map.behavior_entry.should == ""
        @map.behaviors_ctags.should == ["A", "B", "C"]
        @map.behaviors_tags.should == ["A", "B", "C"]

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT needs" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @attributes = {need_entry: "needs description", tags: ["A", "B", "acceptance", "affection" ]}
    end

    describe "with valid params" do

      it "creates needs" do
        put :need, @attributes.merge(:id => @map.id, :format => :json)
        @map.reload

        @map.need_entry.should == @attributes[:need_entry]
        @map.needs_ctags.should == ["A", "B"]
        @map.needs_tags.should == ["A", "B", "acceptance", "affection" ]
        response.body.should_not == nil
        response.should be_success
      end

      it "updates needs" do

        put :need, need_entry: "need update", tags: ["A", "B", "C"], id: @map.id, format: :json
        @map.reload

        @map.need_entry.should == "need update"
        @map.needs_ctags.should == ["A", "B", "C"]
        @map.needs_tags.should == ["A", "B", "C"]

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

  describe "PUT circumstances" do
    before(:each) do
      @map = @user.maps.create! valid_attributes
      @attributes = {circumstance_entry: "circumstances description", circumstance_whats: ["A", "B"],
        circumstance_wheres: ["A", "B"], circumstance_whos: ["A", "B"], circumstance_whens: ["A", "B"]}
    end

    describe "with valid params" do

      it "creates circumstances" do
        put :circumstance, @attributes.merge(:id => @map.id, :format => :json)
        @map.reload

        @map.circumstance_entry.should == @attributes[:circumstance_entry]
        @map.circumstance_whats.should == ["A", "B"]
        @map.circumstance_whens.should == ["A", "B"]
        @map.circumstance_wheres.should == ["A", "B"]
        @map.circumstance_whos.should == ["A", "B"]
        response.body.should_not == nil
        response.should be_success
      end

      it "updates circumstances" do

        put :circumstance, circumstance_entry: "circumstance update", circumstance_whats: ["A", "B", "C"],
          circumstance_wheres: [], circumstance_whos: ["B"], circumstance_whens: ["A"], id: @map.id, format: :json
        @map.reload

        @map.circumstance_entry.should == "circumstance update"
        @map.circumstance_whats.should == ["A", "B", "C"]
        @map.circumstance_wheres.should == []
        @map.circumstance_whos.should == ["B"]
        @map.circumstance_whens.should == ["A"]

        response.body.should_not == nil
        response.should be_success
      end
    end
  end

end 
