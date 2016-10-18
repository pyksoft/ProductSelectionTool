class ItemSerializer < ActiveModel::Serializer
  attributes :id, :item_no, :description, :reactions
end