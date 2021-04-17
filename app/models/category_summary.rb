class CategorySummary < ApplicationRecord
  after_initialize :readonly!
end
