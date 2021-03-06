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

describe ContextPlanTasksController do

  # This should return the minimal set of attributes required to create a valid
  # ContextPlanTask. As you add validations to ContextPlanTask, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "context_plan" => "" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ContextPlanTasksController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all context_plan_tasks as @context_plan_tasks" do
      context_plan_task = ContextPlanTask.create! valid_attributes
      get :index, {}, valid_session
      assigns(:context_plan_tasks).should eq([context_plan_task])
    end
  end

  describe "GET show" do
    it "assigns the requested context_plan_task as @context_plan_task" do
      context_plan_task = ContextPlanTask.create! valid_attributes
      get :show, {:id => context_plan_task.to_param}, valid_session
      assigns(:context_plan_task).should eq(context_plan_task)
    end
  end

  describe "GET new" do
    it "assigns a new context_plan_task as @context_plan_task" do
      get :new, {}, valid_session
      assigns(:context_plan_task).should be_a_new(ContextPlanTask)
    end
  end

  describe "GET edit" do
    it "assigns the requested context_plan_task as @context_plan_task" do
      context_plan_task = ContextPlanTask.create! valid_attributes
      get :edit, {:id => context_plan_task.to_param}, valid_session
      assigns(:context_plan_task).should eq(context_plan_task)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ContextPlanTask" do
        expect {
          post :create, {:context_plan_task => valid_attributes}, valid_session
        }.to change(ContextPlanTask, :count).by(1)
      end

      it "assigns a newly created context_plan_task as @context_plan_task" do
        post :create, {:context_plan_task => valid_attributes}, valid_session
        assigns(:context_plan_task).should be_a(ContextPlanTask)
        assigns(:context_plan_task).should be_persisted
      end

      it "redirects to the created context_plan_task" do
        post :create, {:context_plan_task => valid_attributes}, valid_session
        response.should redirect_to(ContextPlanTask.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved context_plan_task as @context_plan_task" do
        # Trigger the behavior that occurs when invalid params are submitted
        ContextPlanTask.any_instance.stub(:save).and_return(false)
        post :create, {:context_plan_task => { "context_plan" => "invalid value" }}, valid_session
        assigns(:context_plan_task).should be_a_new(ContextPlanTask)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ContextPlanTask.any_instance.stub(:save).and_return(false)
        post :create, {:context_plan_task => { "context_plan" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested context_plan_task" do
        context_plan_task = ContextPlanTask.create! valid_attributes
        # Assuming there are no other context_plan_tasks in the database, this
        # specifies that the ContextPlanTask created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ContextPlanTask.any_instance.should_receive(:update_attributes).with({ "context_plan" => "" })
        put :update, {:id => context_plan_task.to_param, :context_plan_task => { "context_plan" => "" }}, valid_session
      end

      it "assigns the requested context_plan_task as @context_plan_task" do
        context_plan_task = ContextPlanTask.create! valid_attributes
        put :update, {:id => context_plan_task.to_param, :context_plan_task => valid_attributes}, valid_session
        assigns(:context_plan_task).should eq(context_plan_task)
      end

      it "redirects to the context_plan_task" do
        context_plan_task = ContextPlanTask.create! valid_attributes
        put :update, {:id => context_plan_task.to_param, :context_plan_task => valid_attributes}, valid_session
        response.should redirect_to(context_plan_task)
      end
    end

    describe "with invalid params" do
      it "assigns the context_plan_task as @context_plan_task" do
        context_plan_task = ContextPlanTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ContextPlanTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => context_plan_task.to_param, :context_plan_task => { "context_plan" => "invalid value" }}, valid_session
        assigns(:context_plan_task).should eq(context_plan_task)
      end

      it "re-renders the 'edit' template" do
        context_plan_task = ContextPlanTask.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ContextPlanTask.any_instance.stub(:save).and_return(false)
        put :update, {:id => context_plan_task.to_param, :context_plan_task => { "context_plan" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested context_plan_task" do
      context_plan_task = ContextPlanTask.create! valid_attributes
      expect {
        delete :destroy, {:id => context_plan_task.to_param}, valid_session
      }.to change(ContextPlanTask, :count).by(-1)
    end

    it "redirects to the context_plan_tasks list" do
      context_plan_task = ContextPlanTask.create! valid_attributes
      delete :destroy, {:id => context_plan_task.to_param}, valid_session
      response.should redirect_to(context_plan_tasks_url)
    end
  end

end
