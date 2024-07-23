class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.string :status
      t.string :type
      t.string :booking_date
      t.string :time

      t.timestamps
    end
  end
end
