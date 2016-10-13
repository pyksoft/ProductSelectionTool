class Result
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :url, type: String

  validates :title, length: {:within => 2..100}, presence: true

  has_many :triggers, class_name: 'Choice', inverse_of: :result

  def id
    self._id.to_s
  end
end