class Api::ChoicesController < Api::ApiController
  before_action :check_question_presense, only: [:create]
  before_action :check_presense, only: [:update, :destroy]

  def index
    render nothing: true
  end

  def create
    @question = parent_question
    @choice = Choice.new(choice_params)

    if @choice.valid?
      @choice.save
      @question.add_choice @choice
      render json: @choice
    else
      render_api_error('', 400, @choice)
    end
  end

  def destroy
    subject.destroy
    render nothing: true, status: 200    
  end

  def update
    @choice = subject
    if @choice.update(choice_params)
      render json: @choice
    else
      render_api_error('', 400, @choice)
    end
  end

  private

  def check_question_presence
    if parent_question.nil?
      render_api_error('Question not found.', 404)
    end
    true
  end

  def check_presence
    if subject.nil?
      render_api_error('Question not found.', 404)
    end
    true
  end

  def parent_question
    Question.find(params[:question_id])
  end

  def subject
    Choice.find(params[:id])
  end

  def choice_params
    params.require(:choice).permit(:title)
  end
end