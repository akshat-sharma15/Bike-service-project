class AddColumnTotalSlotsToServiceCenter < ActiveRecord::Migration[7.0]
  def change
    add_column :service_centers, :total_slots, :integer
  end
end
