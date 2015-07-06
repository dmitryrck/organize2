class Income < ActiveRecord::Base
  validates :description, :value, presence: true
end
