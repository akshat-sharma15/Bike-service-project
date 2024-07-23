class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.string :date
      t.string :details
      t.string :amount

      t.timestamps
    end
  end
end
