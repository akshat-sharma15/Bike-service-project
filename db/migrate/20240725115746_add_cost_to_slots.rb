class AddCostToSlots < ActiveRecord::Migration[7.0]
  def change
    add_column :slots, :cost, :decimal, precision: 10, scale: 2
  end
end
