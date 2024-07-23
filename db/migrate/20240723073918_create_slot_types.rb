class CreateSlotTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :slot_types do |t|
      t.string :type
      t.string :time

      t.timestamps
    end
  end
end
