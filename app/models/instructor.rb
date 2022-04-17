class Instructor < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :name, :department
  validates :users_id, uniqueness: true
end
