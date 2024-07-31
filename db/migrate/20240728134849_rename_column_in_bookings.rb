class RenameColumnInBookings < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :bikes_id, :bike_id
  end
end
