class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    %w[
      email
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
