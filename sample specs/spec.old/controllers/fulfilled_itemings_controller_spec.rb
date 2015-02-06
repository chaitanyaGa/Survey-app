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

describe FulfilledItemingsController do

  # This should return the minimal set of attributes required to create a valid
  # FulfilledIteming. As you add validations to FulfilledIteming, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FulfilledItemingsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all fulfilled_itemings as @fulfilled_itemings" do
      fulfilled_iteming = FulfilledIteming.create! valid_attributes
      get :index, {}, valid_session
      assigns(:fulfilled_itemings).should eq([fulfilled_iteming])
    end
  end

  describe "GET show" do
    it "assigns the requested fulfilled_iteming as @fulfilled_iteming" do
      fulfilled_iteming = FulfilledIteming.create! valid_attributes
      get :show, {:id => fulfilled_iteming.to_param}, valid_session
      assigns(:fulfilled_iteming).should eq(fulfilled_iteming)
    end
  end

  describe "GET new" do
    it "assigns a new fulfilled_iteming as @fulfilled_iteming" do
      get :new, {}, valid_session
      assigns(:fulfilled_iteming).should be_a_new(FulfilledIteming)
    end
  end

  describe "GET edit" do
    it "assigns the requested fulfilled_iteming as @fulfilled_iteming" do
      fulfilled_iteming = FulfilledIteming.create! valid_attributes
      get :edit, {:id => fulfilled_iteming.to_param}, valid_session
      assigns(:fulfilled_iteming).should eq(fulfilled_iteming)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FulfilledIteming" do
        expect {
          post :create, {:fulfilled_iteming => valid_attributes}, valid_session
        }.to change(FulfilledIteming, :count).by(1)
      end

      it "assigns a newly created fulfilled_iteming as @fulfilled_iteming" do
        post :create, {:fulfilled_iteming => valid_attributes}, valid_session
        assigns(:fulfilled_iteming).should be_a(FulfilledIteming)
        assigns(:fulfilled_iteming).should be_persisted
      end

      it "redirects to the created fulfilled_iteming" do
        post :create, {:fulfilled_iteming => valid_attributes}, valid_session
        response.should redirect_to(FulfilledIteming.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved fulfilled_iteming as @fulfilled_iteming" do
        # Trigger the behavior that occurs when invalid params are submitted
        FulfilledIteming.any_instance.stub(:save).and_return(false)
        post :create, {:fulfilled_iteming => {}}, valid_session
        assigns(:fulfilled_iteming).should be_a_new(FulfilledIteming)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FulfilledIteming.any_instance.stub(:save).and_return(false)
        post :create, {:fulfilled_iteming => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested fulfilled_iteming" do
        fulfilled_iteming = FulfilledIteming.create! valid_attributes
        # Assuming there are no other fulfilled_itemings in the database, this
        # specifies that the FulfilledIteming created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FulfilledIteming.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => fulfilled_iteming.to_param, :fulfilled_iteming => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested fulfilled_iteming as @fulfilled_iteming" do
        fulfilled_iteming = FulfilledIteming.create! valid_attributes
        put :update, {:id => fulfilled_iteming.to_param, :fulfilled_iteming => valid_attributes}, valid_session
        assigns(:fulfilled_iteming).should eq(fulfilled_iteming)
      end

      it "redirects to the fulfilled_iteming" do
        fulfilled_iteming = FulfilledIteming.create! valid_attributes
        put :update, {:id => fulfilled_iteming.to_param, :fulfilled_iteming => valid_attributes}, valid_session
        response.should redirect_to(fulfilled_iteming)
      end
    end

    describe "with invalid params" do
      it "assigns the fulfilled_iteming as @fulfilled_iteming" do
        fulfilled_iteming = FulfilledIteming.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FulfilledIteming.any_instance.stub(:save).and_return(false)
        put :update, {:id => fulfilled_iteming.to_param, :fulfilled_iteming => {}}, valid_session
        assigns(:fulfilled_iteming).should eq(fulfilled_iteming)
      end

      it "re-renders the 'edit' template" do
        fulfilled_iteming = FulfilledIteming.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FulfilledIteming.any_instance.stub(:save).and_return(false)
        put :update, {:id => fulfilled_iteming.to_param, :fulfilled_iteming => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested fulfilled_iteming" do
      fulfilled_iteming = FulfilledIteming.create! valid_attributes
      expect {
        delete :destroy, {:id => fulfilled_iteming.to_param}, valid_session
      }.to change(FulfilledIteming, :count).by(-1)
    end

    it "redirects to the fulfilled_itemings list" do
      fulfilled_iteming = FulfilledIteming.create! valid_attributes
      delete :destroy, {:id => fulfilled_iteming.to_param}, valid_session
      response.should redirect_to(fulfilled_itemings_url)
    end
  end

end
