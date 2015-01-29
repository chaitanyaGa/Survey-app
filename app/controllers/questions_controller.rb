class QuestionsController < ApplicationController
  def new
  end

  def show
  end

  def destroy
  end

  def update
  end
  def edit
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
  end

  def index
    @survey = Survey.find(params[:survey_id])
    @questions = Survey.find(params[:survey_id]).questions
  end
end
