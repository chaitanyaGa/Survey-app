require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BeliefAlternateFramesController do

  # This should return the minimal set of attributes required to create a valid
  # BeliefAlternateFrame. As you add validations to BeliefAlternateFrame, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BeliefAlternateFramesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all belief_alternate_frames as @belief_alternate_frames" do
      belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
      get :index, {}, valid_session
      assigns(:belief_alternate_frames).should eq([belief_alternate_frame])
    end
  end

  describe "GET show" do
    it "assigns the requested belief_alternate_frame as @belief_alternate_frame" do
      belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
      get :show, {:id => belief_alternate_frame.to_param}, valid_session
      assigns(:belief_alternate_frame).should eq(belief_alternate_frame)
    end
  end

  describe "GET new" do
    it "assigns a new belief_alternate_frame as @belief_alternate_frame" do
      get :new, {}, valid_session
      assigns(:belief_alternate_frame).should be_a_new(BeliefAlternateFrame)
    end
  end

  describe "GET edit" do
    it "assigns the requested belief_alternate_frame as @belief_alternate_frame" do
      belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
      get :edit, {:id => belief_alternate_frame.to_param}, valid_session
      assigns(:belief_alternate_frame).should eq(belief_alternate_frame)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BeliefAlternateFrame" do
        expect {
          post :create, {:belief_alternate_frame => valid_attributes}, valid_session
        }.to change(BeliefAlternateFrame, :count).by(1)
      end

      it "assigns a newly created belief_alternate_frame as @belief_alternate_frame" do
        post :create, {:belief_alternate_frame => valid_attributes}, valid_session
        assigns(:belief_alternate_frame).should be_a(BeliefAlternateFrame)
        assigns(:belief_alternate_frame).should be_persisted
      end

      it "redirects to the created belief_alternate_frame" do
        post :create, {:belief_alternate_frame => valid_attributes}, valid_session
        response.should redirect_to(BeliefAlternateFrame.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved belief_alternate_frame as @belief_alternate_frame" do
        # Trigger the behavior that occurs when invalid params are submitted
        BeliefAlternateFrame.any_instance.stub(:save).and_return(false)
        post :create, {:belief_alternate_frame => {}}, valid_session
        assigns(:belief_alternate_frame).should be_a_new(BeliefAlternateFrame)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BeliefAlternateFrame.any_instance.stub(:save).and_return(false)
        post :create, {:belief_alternate_frame => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested belief_alternate_frame" do
        belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
        # Assuming there are no other belief_alternate_frames in the database, this
        # specifies that the BeliefAlternateFrame created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BeliefAlternateFrame.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => belief_alternate_frame.to_param, :belief_alternate_frame => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested belief_alternate_frame as @belief_alternate_frame" do
        belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
        put :update, {:id => belief_alternate_frame.to_param, :belief_alternate_frame => valid_attributes}, valid_session
        assigns(:belief_alternate_frame).should eq(belief_alternate_frame)
      end

      it "redirects to the belief_alternate_frame" do
        belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
        put :update, {:id => belief_alternate_frame.to_param, :belief_alternate_frame => valid_attributes}, valid_session
        response.should redirect_to(belief_alternate_frame)
      end
    end

    describe "with invalid params" do
      it "assigns the belief_alternate_frame as @belief_alternate_frame" do
        belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BeliefAlternateFrame.any_instance.stub(:save).and_return(false)
        put :update, {:id => belief_alternate_frame.to_param, :belief_alternate_frame => {}}, valid_session
        assigns(:belief_alternate_frame).should eq(belief_alternate_frame)
      end

      it "re-renders the 'edit' template" do
        belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BeliefAlternateFrame.any_instance.stub(:save).and_return(false)
        put :update, {:id => belief_alternate_frame.to_param, :belief_alternate_frame => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested belief_alternate_frame" do
      belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
      expect {
        delete :destroy, {:id => belief_alternate_frame.to_param}, valid_session
      }.to change(BeliefAlternateFrame, :count).by(-1)
    end

    it "redirects to the belief_alternate_frames list" do
      belief_alternate_frame = BeliefAlternateFrame.create! valid_attributes
      delete :destroy, {:id => belief_alternate_frame.to_param}, valid_session
      response.should redirect_to(belief_alternate_frames_url)
    end
  end

end
