class Choice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :is_dead_end, type: Boolean, default: false

  belongs_to :question, class_name: 'Question', inverse_of: :choices, optional: true
  belongs_to :lead, class_name: 'Question', inverse_of: :triggers, optional: true 
  belongs_to :result, class_name: 'Result', inverse_of: :triggers, optional: true

  validates :title, length: {:within => 2..100}, presence: true
  
  def id
    self._id.to_s
  end

  def next
    if !lead.blank? then
      'quest'
    elsif !result.blank? then
      'result'
    else
      'deadend'
    end
  end
  
  def lead
    self.lead_id.to_s
  end

  def result
    self.result_id.to_s
  end
end