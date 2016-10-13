class Api::ResultsController < Api::ApiController
  before_action :check_presence, only: [:update, :destroy]

  def index
    results = Result.all
    render json: results
  end

  def create
    @result = Result.new(result_params)

    if @result.valid?
      @result.save
      render json: @result
    else
      render_api_error('', 400, @result)
    end
  end

  def destroy
    subject.destroy
    render nothing: true, status: 200    
  end

  def update
    @result = subject

    if @result.update(result_params)
      render json: @result
    else
      render_api_error('', 400, @result)
    end
  end

  private

  def check_presence
    if subject.nil?
      render_api_error('Result not found.', 404)
    end
    true
  end

  def subject
    Result.find(params[:id])
  end

  def result_params
    params.require(:result).permit(:title, :url)
  end
end