class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.string :status
      t.integer :waitlist_position

      t.timestamps
    end
  end
end
