class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :item_no, type: String
  field :description, type: String
  field :reactions, type: Integer

  belongs_to :result, class_name: 'Result', inverse_of: :items, optional: true
  def id
    self._id.to_s
  end
end