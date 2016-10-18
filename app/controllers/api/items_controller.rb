class Api::ItemsController < Api::ApiController
  before_action :check_result_presence, only: [:create]
  before_action :check_presence, only: [:update, :destroy]

  def index
    render nothing: true
  end

  def create
    @result = parent_result
    @item = Item.new(item_params)

    if @item.valid?
      @item.save
      @result.add_item @item
      render json: @item
    else
      render_api_error('', 400, @item)
    end
  end

  def destroy
    subject.destroy
    render nothing: true, status: 200
  end

  def update
    @item = subject
    if @item.update(item_params)
      render json: @item
    else
      render_api_error('', 400, @item)
    end
  end

  private

  def check_result_presence
    if parent_result.nil?
      render_api_error('Result not found.', 404)
    end
    true
  end

  def check_presence
    if subject.nil?
      render_api_error('Item not found.', 404)
    end
    true
  end

  def parent_result
    Result.find(params[:result_id])
  end

  def subject
    Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_no, :description, :reactions)
  end
end