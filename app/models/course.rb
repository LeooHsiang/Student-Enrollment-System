class Course < ApplicationRecord
  validates_presence_of :name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :code, :capacity, :room
  validates :code, uniqueness: true, format: {with: /\b[A-Z]{3}[0-9]{3}\b/}
  validates :start_time, format: { with: /\A^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])\z/}
  validates :end_time, format: { with: /\A^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])\z/}
  validates :capacity, numericality: { greater_than: 0 }
  validates :waitlist_capacity, numericality: { greater_than_or_equal_to: 0 }
  validates_comparison_of :end_time, greater_than: :start_time
end

