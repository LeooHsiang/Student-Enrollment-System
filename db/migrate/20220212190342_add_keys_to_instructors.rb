class AddKeysToInstructors < ActiveRecord::Migration[7.0]
  def change
    add_reference :instructors, :users, null: false, foreign_key: true
  end
end
