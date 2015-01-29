class SurveysController < ApplicationController

  # action
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def survey_params
    params.require(:survey).permit(:name,:survey_type)
  end

end
