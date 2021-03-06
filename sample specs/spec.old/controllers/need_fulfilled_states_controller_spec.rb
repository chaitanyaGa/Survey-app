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

describe NeedFulfilledStatesController do

  # This should return the minimal set of attributes required to create a valid
  # NeedFulfilledState. As you add validations to NeedFulfilledState, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NeedFulfilledStatesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all need_fulfilled_states as @need_fulfilled_states" do
      need_fulfilled_state = NeedFulfilledState.create! valid_attributes
      get :index, {}, valid_session
      assigns(:need_fulfilled_states).should eq([need_fulfilled_state])
    end
  end

  describe "GET show" do
    it "assigns the requested need_fulfilled_state as @need_fulfilled_state" do
      need_fulfilled_state = NeedFulfilledState.create! valid_attributes
      get :show, {:id => need_fulfilled_state.to_param}, valid_session
      assigns(:need_fulfilled_state).should eq(need_fulfilled_state)
    end
  end

  describe "GET new" do
    it "assigns a new need_fulfilled_state as @need_fulfilled_state" do
      get :new, {}, valid_session
      assigns(:need_fulfilled_state).should be_a_new(NeedFulfilledState)
    end
  end

  describe "GET edit" do
    it "assigns the requested need_fulfilled_state as @need_fulfilled_state" do
      need_fulfilled_state = NeedFulfilledState.create! valid_attributes
      get :edit, {:id => need_fulfilled_state.to_param}, valid_session
      assigns(:need_fulfilled_state).should eq(need_fulfilled_state)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new NeedFulfilledState" do
        expect {
          post :create, {:need_fulfilled_state => valid_attributes}, valid_session
        }.to change(NeedFulfilledState, :count).by(1)
      end

      it "assigns a newly created need_fulfilled_state as @need_fulfilled_state" do
        post :create, {:need_fulfilled_state => valid_attributes}, valid_session
        assigns(:need_fulfilled_state).should be_a(NeedFulfilledState)
        assigns(:need_fulfilled_state).should be_persisted
      end

      it "redirects to the created need_fulfilled_state" do
        post :create, {:need_fulfilled_state => valid_attributes}, valid_session
        response.should redirect_to(NeedFulfilledState.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved need_fulfilled_state as @need_fulfilled_state" do
        # Trigger the behavior that occurs when invalid params are submitted
        NeedFulfilledState.any_instance.stub(:save).and_return(false)
        post :create, {:need_fulfilled_state => {}}, valid_session
        assigns(:need_fulfilled_state).should be_a_new(NeedFulfilledState)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        NeedFulfilledState.any_instance.stub(:save).and_return(false)
        post :create, {:need_fulfilled_state => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested need_fulfilled_state" do
        need_fulfilled_state = NeedFulfilledState.create! valid_attributes
        # Assuming there are no other need_fulfilled_states in the database, this
        # specifies that the NeedFulfilledState created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        NeedFulfilledState.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => need_fulfilled_state.to_param, :need_fulfilled_state => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested need_fulfilled_state as @need_fulfilled_state" do
        need_fulfilled_state = NeedFulfilledState.create! valid_attributes
        put :update, {:id => need_fulfilled_state.to_param, :need_fulfilled_state => valid_attributes}, valid_session
        assigns(:need_fulfilled_state).should eq(need_fulfilled_state)
      end

      it "redirects to the need_fulfilled_state" do
        need_fulfilled_state = NeedFulfilledState.create! valid_attributes
        put :update, {:id => need_fulfilled_state.to_param, :need_fulfilled_state => valid_attributes}, valid_session
        response.should redirect_to(need_fulfilled_state)
      end
    end

    describe "with invalid params" do
      it "assigns the need_fulfilled_state as @need_fulfilled_state" do
        need_fulfilled_state = NeedFulfilledState.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        NeedFulfilledState.any_instance.stub(:save).and_return(false)
        put :update, {:id => need_fulfilled_state.to_param, :need_fulfilled_state => {}}, valid_session
        assigns(:need_fulfilled_state).should eq(need_fulfilled_state)
      end

      it "re-renders the 'edit' template" do
        need_fulfilled_state = NeedFulfilledState.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        NeedFulfilledState.any_instance.stub(:save).and_return(false)
        put :update, {:id => need_fulfilled_state.to_param, :need_fulfilled_state => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested need_fulfilled_state" do
      need_fulfilled_state = NeedFulfilledState.create! valid_attributes
      expect {
        delete :destroy, {:id => need_fulfilled_state.to_param}, valid_session
      }.to change(NeedFulfilledState, :count).by(-1)
    end

    it "redirects to the need_fulfilled_states list" do
      need_fulfilled_state = NeedFulfilledState.create! valid_attributes
      delete :destroy, {:id => need_fulfilled_state.to_param}, valid_session
      response.should redirect_to(need_fulfilled_states_url)
    end
  end

end
