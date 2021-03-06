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

describe RegularPlanTasksController do

  # This should return the minimal set of attributes required to create a valid
  # RegularPlanTask. As you add validations to RegularPlanTask, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "regular_plan" => "" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RegularPlanTasksController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all regular_plan_tasks as @regular_plan_tasks" do
      regular_plan_task = RegularPlanTask.create! valid_attributes
      get :index, {}, valid_session
      assigns(:regular_plan_tasks).should eq([regular_plan_task])
    end
  end

  describe "GET show" do
    it "assigns the requested regular_plan_task as @regular_plan_task" do
      regular_plan_task = RegularPlanTask.create! valid_attributes
      get :show, {:id => regular_plan_task.to_param}, valid_session
      assigns(:regular_plan_task).should eq(regular_plan_task)
    end
  end

  describe "GET new" do
    it "assigns a new regular_plan_task as @regular_plan_task" do
      get :new, {}, valid_session
      assigns(:regular_plan_task).should be_a_new(RegularPlanTask)
    end
  end

  describe "GET edit" do
    it "assigns the requested regular_plan_task as @regular_plan_task" do
      regular_plan_task = RegularPlanTask.create! valid_attributes
      get :edit, {:id => regular_plan_task.to_param}, valid_session
      assigns(:regular_plan_task).should eq(regular_plan_task)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new RegularPlanTask" do
        expect {
          post :create, {:regular_plan_task => valid_attributes}, valid_session
        }.to change(RegularPlanTask, :count).by(1)
      end

      it "assigns a newly created regular_plan_task as @regular_plan_task" do
        post :create, {:regular_plan_task => valid_attributes}, valid_session
        assigns(:regular_plan_task).should be_a(RegularPlanTask)
        assigns(:regular_plan_task).should be_persisted
      end

      it "redirects to the created regular_plan_task" do
        post :create, {:regular_plan_task => valid_attributes}, valid_session
        response.should redirect_to(RegularPlanTask.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved regular_plan_task as @regular_plan_task" do
        # Trigger the behavior that occurs when invalid params are submitted
        RegularPlanTask.any_instance.stub(:save).and_return(false)
        post :create, {:regular_plan_task => { "regular_plan" => "invalid value" }}, valid_session
        assigns(:regular_plan_task).should be_a_new(RegularPlanTask)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RegularPlanTask.any_instance.stub(:save).and_return(false)
        post :create, {:regular_plan_task => { "regular_plan" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested regular_plan_task" do
        regular_plan_task = RegularPlanTask.create! valid_attributes
        # Assuming there are no other regular_plan_tasks in the database, this
        # specifies that the RegularPlanTask created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RegularPlanTask.any_instance.should_receive(:update_attributes).with({ "regular_plan" => "" })
        put :update, {:id => regular_plan_task.to_param, :regular_plan_task => { "regular_plan" => "" }}, valid_session
      end

      it "assigns the requested regular_plan_task as @regular_plan_task" do
        regular_plan_task = RegularPlanTask.create! valid_attributes
        put :update, {:id => regular_plan_task.to_param, :regular_plan_task => valid_attributes}, valid_session
        assigns(:regular_plan_task).should eq(regular_plan_task)
      end

      it "redirects to the regular_plan_task" do
        regular_plan_task = RegularPlanTask.create! valid_attributes
        put :update, {:id => regular_plan_task.to_param, :regular_plan_task => valid_attributes}, valid_session
        response.should redirect_to(regular_plan_task)
      end
    end

    describe "with invalid params" do
      it "assigns the regular_plan_task as @regular_plan_task" do
        regular_plan_task = RegularPlanTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RegularPlanTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => regular_plan_task.to_param, :regular_plan_task => { "regular_plan" => "invalid value" }}, valid_session
        assigns(:regular_plan_task).should eq(regular_plan_task)
      end

      it "re-renders the 'edit' template" do
        regular_plan_task = RegularPlanTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RegularPlanTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => regular_plan_task.to_param, :regular_plan_task => { "regular_plan" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested regular_plan_task" do
      regular_plan_task = RegularPlanTask.create! valid_attributes
      expect {
        delete :destroy, {:id => regular_plan_task.to_param}, valid_session
      }.to change(RegularPlanTask, :count).by(-1)
    end

    it "redirects to the regular_plan_tasks list" do
      regular_plan_task = RegularPlanTask.create! valid_attributes
      delete :destroy, {:id => regular_plan_task.to_param}, valid_session
      response.should redirect_to(regular_plan_tasks_url)
    end
  end

end
