class Income < Movement
  validates :description, :value, presence: true
end
