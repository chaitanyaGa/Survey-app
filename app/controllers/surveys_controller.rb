class SurveysController < ApplicationController

  before_filter :user_login
  # action
  def index
    @surveys = Survey.all
    @users = User.all
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def new
    @survey = Survey.new
    #2.times do
     # @question = @survey.questions.build
    #end
  end

  def update
    @survey = Survey.find(params[:id])
    if @survey.update_attributes(survey_params)
      flash[:notice] = 'Survey Successfully updated'
      redirect_to surveys_path
    else
      flash[:notice] = 'update not successful'
      render 'edit'
    end
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      flash[:notice] = 'Survey Successfully created'
      redirect_to surveys_path
    else
      flash[:notice] = 'Something went wrong'
      render 'new'
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  def destroy
    @survey = Survey.find(params[:id])
    if @survey.destroy
      flash[:notice] = 'survey deleted'
      redirect_to surveys_path
    else
      flash[:notice] = 'survey not deleted'
      redirect_to surveys_path
    end
  end

  private

  def user_login
    if !session[:userid]
      flash[:notice] = 'you are not logged in'
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end

  def survey_params
    params.require(:survey).permit(:name,:type_of_survey,:conducted,:question_count)
  end

end
