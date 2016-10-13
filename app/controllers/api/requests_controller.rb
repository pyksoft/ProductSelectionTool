class Api::RequestsController < Api::ApiController
  def recommend
    SendGrid::Mailer.request_recommendation(description: recommend_params[:description], email: recommend_params[:email])
    render nothing: true, status: 200
  end

  def inquire
    hash_str = {
      :additional => 'Additional Information',
      :price => 'Price',
      :sample => 'Product Sample'
    }

    included_items = []
    full_string_hash = inquire_params[:email_me].each do |k, v|
      if v then
        included_items << hash_str.with_indifferent_access[k]
      end
    end

    SendGrid::Mailer.inquire_product(product: inquire_params[:product], items: included_items.join(', '), email: inquire_params[:email])
    render nothing: true, status: 200
  end

  private

  def recommend_params
    params.require(:info).permit(:description, :email)
  end

  def inquire_params
    params.require(:info).permit(:product, {:email_me => [:additional, :price, :sample]}, :email)
  end
end