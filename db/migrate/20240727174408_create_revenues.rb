class CreateRevenues < ActiveRecord::Migration[7.0]
  def change
    create_table :revenues do |t|
      t.references :service_center, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :revenue, null: false, default: 0.0

      t.timestamps
    end
    add_index :revenues, [:service_center_id, :date], unique: true
  end
end
