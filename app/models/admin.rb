class Admin < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :name, :phone_number
  validates :users_id, uniqueness: true
end
