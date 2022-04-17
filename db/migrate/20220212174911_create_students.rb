class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.date :date_of_birth
      t.string :phone_number
      t.string :major

      t.timestamps
    end
  end
end
