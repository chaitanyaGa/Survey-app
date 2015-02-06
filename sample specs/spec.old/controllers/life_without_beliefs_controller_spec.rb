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

describe LifeWithoutBeliefsController do

  # This should return the minimal set of attributes required to create a valid
  # LifeWithoutBelief. As you add validations to LifeWithoutBelief, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LifeWithoutBeliefsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all life_without_beliefs as @life_without_beliefs" do
      life_without_belief = LifeWithoutBelief.create! valid_attributes
      get :index, {}, valid_session
      assigns(:life_without_beliefs).should eq([life_without_belief])
    end
  end

  describe "GET show" do
    it "assigns the requested life_without_belief as @life_without_belief" do
      life_without_belief = LifeWithoutBelief.create! valid_attributes
      get :show, {:id => life_without_belief.to_param}, valid_session
      assigns(:life_without_belief).should eq(life_without_belief)
    end
  end

  describe "GET new" do
    it "assigns a new life_without_belief as @life_without_belief" do
      get :new, {}, valid_session
      assigns(:life_without_belief).should be_a_new(LifeWithoutBelief)
    end
  end

  describe "GET edit" do
    it "assigns the requested life_without_belief as @life_without_belief" do
      life_without_belief = LifeWithoutBelief.create! valid_attributes
      get :edit, {:id => life_without_belief.to_param}, valid_session
      assigns(:life_without_belief).should eq(life_without_belief)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LifeWithoutBelief" do
        expect {
          post :create, {:life_without_belief => valid_attributes}, valid_session
        }.to change(LifeWithoutBelief, :count).by(1)
      end

      it "assigns a newly created life_without_belief as @life_without_belief" do
        post :create, {:life_without_belief => valid_attributes}, valid_session
        assigns(:life_without_belief).should be_a(LifeWithoutBelief)
        assigns(:life_without_belief).should be_persisted
      end

      it "redirects to the created life_without_belief" do
        post :create, {:life_without_belief => valid_attributes}, valid_session
        response.should redirect_to(LifeWithoutBelief.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved life_without_belief as @life_without_belief" do
        # Trigger the behavior that occurs when invalid params are submitted
        LifeWithoutBelief.any_instance.stub(:save).and_return(false)
        post :create, {:life_without_belief => {}}, valid_session
        assigns(:life_without_belief).should be_a_new(LifeWithoutBelief)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LifeWithoutBelief.any_instance.stub(:save).and_return(false)
        post :create, {:life_without_belief => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested life_without_belief" do
        life_without_belief = LifeWithoutBelief.create! valid_attributes
        # Assuming there are no other life_without_beliefs in the database, this
        # specifies that the LifeWithoutBelief created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LifeWithoutBelief.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => life_without_belief.to_param, :life_without_belief => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested life_without_belief as @life_without_belief" do
        life_without_belief = LifeWithoutBelief.create! valid_attributes
        put :update, {:id => life_without_belief.to_param, :life_without_belief => valid_attributes}, valid_session
        assigns(:life_without_belief).should eq(life_without_belief)
      end

      it "redirects to the life_without_belief" do
        life_without_belief = LifeWithoutBelief.create! valid_attributes
        put :update, {:id => life_without_belief.to_param, :life_without_belief => valid_attributes}, valid_session
        response.should redirect_to(life_without_belief)
      end
    end

    describe "with invalid params" do
      it "assigns the life_without_belief as @life_without_belief" do
        life_without_belief = LifeWithoutBelief.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LifeWithoutBelief.any_instance.stub(:save).and_return(false)
        put :update, {:id => life_without_belief.to_param, :life_without_belief => {}}, valid_session
        assigns(:life_without_belief).should eq(life_without_belief)
      end

      it "re-renders the 'edit' template" do
        life_without_belief = LifeWithoutBelief.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LifeWithoutBelief.any_instance.stub(:save).and_return(false)
        put :update, {:id => life_without_belief.to_param, :life_without_belief => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested life_without_belief" do
      life_without_belief = LifeWithoutBelief.create! valid_attributes
      expect {
        delete :destroy, {:id => life_without_belief.to_param}, valid_session
      }.to change(LifeWithoutBelief, :count).by(-1)
    end

    it "redirects to the life_without_beliefs list" do
      life_without_belief = LifeWithoutBelief.create! valid_attributes
      delete :destroy, {:id => life_without_belief.to_param}, valid_session
      response.should redirect_to(life_without_beliefs_url)
    end
  end

end
