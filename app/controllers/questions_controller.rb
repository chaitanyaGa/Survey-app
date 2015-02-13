class QuestionsController < ApplicationController

  before_filter :user_login
  def create
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.build(question_params)
    if @question.save
      flash[:notice] = 'Successsfully created'
      redirect_to survey_questions_path(@survey.id),status: 301
      #render js: "alert('Hello Rails');"
      #render xml: @question
      #render json: @product
    else
      flash[:notice] = 'not Successsfully created'
      redirect_to survey_questions_path(@survey.id)
    end
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.build
    4.times do
      @question.options.build
    end
  end

  def show
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
    
=begin
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => request.url, :level => :l, :unit => 10 }
      format.png  { render :qrcode => request.url }
      format.gif  { render :qrcode => request.url }
      format.jpeg { render :qrcode => request.url }
    end

=end
    @qr = RQRCode::QRCode.new(@question.question + @question.options.all.pluck(:option).to_s+"\n recorded at:"+ Time.now.strftime("%d.%m.%y %H:%M"), :size => 12, :level => :h )
    @image = @qr.to_img
    @image.resize(300,300).save("./app/assets/images/c.png")
  end

  def destroy
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
    if @question.destroy
      flash[:notice] = 'successfully delete'
      redirect_to survey_questions_path(@survey.id)
    else
      flash[:notice] = 'not deleted'
      redirect_to survey_questions_path(@survey.id)
    end
  end

  def update
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
    if @question.update_attributes(question_params)
      flash[:notice] = 'Question Successfully updated'
      redirect_to survey_questions_path(@survey.id)
    else
      flash[:notice] = 'Question not successful'
      redirect_to survey_questions_path(@survey.id)
    end
  end

  def edit
    @survey = Survey.find(params[:survey_id])
    @question = @survey.questions.find(params[:id])
  end

  def index
    @survey = Survey.find(params[:survey_id])
    @questions = Survey.find(params[:survey_id]).questions
  end

  private

  def user_login
    if !session[:userid]
      flash[:notice] = 'you are not logged in'
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end

  def question_params
    params.require(:question).permit(:question,options_attributes: [:id, :option])
  end

end
