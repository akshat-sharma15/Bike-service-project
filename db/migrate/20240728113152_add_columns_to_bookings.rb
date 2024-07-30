class AddColumnsToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :cost, :decimal, default: 0.0
    add_column :bookings, :booking_date, :date
    add_column :bookings, :rental_days, :integer
    add_column :bookings, :return_date, :date
  end
end
