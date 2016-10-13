class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :is_root, type: Boolean, default: false

  has_many :choices, class_name: 'Choice', inverse_of: :question, dependent: :destroy
  has_many :triggers, class_name: 'Choice', inverse_of: :lead

  validates :title, length: {:within => 5..200}, presence: true
  
  def id
    self._id.to_s
  end
  
  def add_choice(choice)
    self.choices << choice
    self.save
  end

  def self.clear_root
    Question.update_all(:is_root => false)
  end
end