class Account < ActiveRecord::Base
  validates :name, :start_balance, :current_balance, presence: true
end
