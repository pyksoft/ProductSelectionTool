class Choice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  belongs_to :question, class_name: 'Question', inverse_of: choices, optional: true

  validates :title, length: {:within => 2..100}, presense: true
  
end