class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_root
  has_many :choices
end