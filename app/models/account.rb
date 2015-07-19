class Account < ActiveRecord::Base
  validates :name, :start_balance, :current_balance, presence: true

  has_many :movements, dependent: :restrict_with_error

  def to_s
    name
  end
end
