class AddKeysToStudents < ActiveRecord::Migration[7.0]
  def change
    add_reference :students, :users, null: false, foreign_key: true
  end
end