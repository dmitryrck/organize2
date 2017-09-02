class Transfer < ActiveRecord::Base
  include Datable
  include Confirmable

  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'

  validates :value, :source, :destination, :date, presence: true

  def to_s
    "#{self.class.model_name.human}##{id}"
  end
end
