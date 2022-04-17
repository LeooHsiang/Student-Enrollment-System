class AddKeysToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_reference :enrollments, :courses, null: false, foreign_key: true
    add_reference :enrollments, :students, null: false, foreign_key: true
  end
end
