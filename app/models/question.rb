class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  has_many :choices, class_name: 'Choice', inverse_of: :question, dependent: :destroy

  validates :title, length: {:within => 5..200}, presense: true
  
  def add_choice(choice)
    self.choices << choice
    self.save
  end
end