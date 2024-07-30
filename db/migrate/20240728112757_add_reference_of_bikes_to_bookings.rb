class AddReferenceOfBikesToBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :bikes, null: false, foreign_key: true
  end
end
