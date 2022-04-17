class Student < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :name, :date_of_birth, :phone_number, :major
  validates :users_id, uniqueness: true
end
