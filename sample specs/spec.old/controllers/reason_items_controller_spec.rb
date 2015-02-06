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

describe ReasonItemsController do

  # This should return the minimal set of attributes required to create a valid
  # ReasonItem. As you add validations to ReasonItem, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ReasonItemsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all reason_items as @reason_items" do
      reason_item = ReasonItem.create! valid_attributes
      get :index, {}, valid_session
      assigns(:reason_items).should eq([reason_item])
    end
  end

  describe "GET show" do
    it "assigns the requested reason_item as @reason_item" do
      reason_item = ReasonItem.create! valid_attributes
      get :show, {:id => reason_item.to_param}, valid_session
      assigns(:reason_item).should eq(reason_item)
    end
  end

  describe "GET new" do
    it "assigns a new reason_item as @reason_item" do
      get :new, {}, valid_session
      assigns(:reason_item).should be_a_new(ReasonItem)
    end
  end

  describe "GET edit" do
    it "assigns the requested reason_item as @reason_item" do
      reason_item = ReasonItem.create! valid_attributes
      get :edit, {:id => reason_item.to_param}, valid_session
      assigns(:reason_item).should eq(reason_item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ReasonItem" do
        expect {
          post :create, {:reason_item => valid_attributes}, valid_session
        }.to change(ReasonItem, :count).by(1)
      end

      it "assigns a newly created reason_item as @reason_item" do
        post :create, {:reason_item => valid_attributes}, valid_session
        assigns(:reason_item).should be_a(ReasonItem)
        assigns(:reason_item).should be_persisted
      end

      it "redirects to the created reason_item" do
        post :create, {:reason_item => valid_attributes}, valid_session
        response.should redirect_to(ReasonItem.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reason_item as @reason_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReasonItem.any_instance.stub(:save).and_return(false)
        post :create, {:reason_item => {}}, valid_session
        assigns(:reason_item).should be_a_new(ReasonItem)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReasonItem.any_instance.stub(:save).and_return(false)
        post :create, {:reason_item => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested reason_item" do
        reason_item = ReasonItem.create! valid_attributes
        # Assuming there are no other reason_items in the database, this
        # specifies that the ReasonItem created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ReasonItem.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => reason_item.to_param, :reason_item => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested reason_item as @reason_item" do
        reason_item = ReasonItem.create! valid_attributes
        put :update, {:id => reason_item.to_param, :reason_item => valid_attributes}, valid_session
        assigns(:reason_item).should eq(reason_item)
      end

      it "redirects to the reason_item" do
        reason_item = ReasonItem.create! valid_attributes
        put :update, {:id => reason_item.to_param, :reason_item => valid_attributes}, valid_session
        response.should redirect_to(reason_item)
      end
    end

    describe "with invalid params" do
      it "assigns the reason_item as @reason_item" do
        reason_item = ReasonItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReasonItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => reason_item.to_param, :reason_item => {}}, valid_session
        assigns(:reason_item).should eq(reason_item)
      end

      it "re-renders the 'edit' template" do
        reason_item = ReasonItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReasonItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => reason_item.to_param, :reason_item => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reason_item" do
      reason_item = ReasonItem.create! valid_attributes
      expect {
        delete :destroy, {:id => reason_item.to_param}, valid_session
      }.to change(ReasonItem, :count).by(-1)
    end

    it "redirects to the reason_items list" do
      reason_item = ReasonItem.create! valid_attributes
      delete :destroy, {:id => reason_item.to_param}, valid_session
      response.should redirect_to(reason_items_url)
    end
  end

end