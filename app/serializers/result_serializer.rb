class ResultSerializer < ActiveModel::Serializer
  attributes :id, :title, :url
  has_many :items
end