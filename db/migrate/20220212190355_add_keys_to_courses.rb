class AddKeysToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :instructors, null: false, foreign_key: true
    add_reference :courses, :statuses, null: false, foreign_key: true
  end
end
