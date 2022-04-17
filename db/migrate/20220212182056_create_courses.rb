class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :weekday_one
      t.string :weekday_two
      t.string :start_time
      t.string :end_time
      t.string :code
      t.integer :capacity
      t.integer :available_capacity
      t.integer :waitlist_capacity
      t.integer :avaialable_waitlist_capacity
      t.string :room

      t.timestamps
    end
  end
end
