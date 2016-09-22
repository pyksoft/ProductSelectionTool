class Api::QuestionsController < Api::ApiController
  before_action :check_presence, only: [:update, :destroy]

  def index
    questions = Question.all
    render json: questions
  end

  def create
    @question = Question.new(qs_params)

    if @question.valid?
      @question.save
      render json: @question
    else
      render_api_error('', 400, @question)
    end
  end

  def destroy
    subject.destroy
    render nothing: true, status: 200    
  end

  def update
    @question = subject
    if @question.update(qs_params)
      render json: @question
    else
      render_api_error('', 400, @question)
    end
  end

  private

  def check_presence
    if subject.nil?
      render_api_error('Question not found.', 404)
    end
    true
  end

  def subject
    Question.find(params[:id])
  end

  def qs_params
    params.require(:question).permit(:name)
  end
end