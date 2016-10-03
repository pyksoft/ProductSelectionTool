class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  has_many :choices, class_name: 'Choice', inverse_of: :question, dependent: :destroy

  validates :title, length: {:within => 5..200}, presence: true
  
  def id
    self._id.to_s
  end
  
  def add_choice(choice)
    self.choices << choice
    self.save
  end
end