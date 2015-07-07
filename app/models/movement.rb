class Movement < ActiveRecord::Base
  self.inheritance_column = :kind
end
