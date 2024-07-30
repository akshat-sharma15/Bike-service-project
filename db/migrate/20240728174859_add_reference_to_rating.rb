class AddReferenceToRating < ActiveRecord::Migration[7.0]
  def change
    add_reference :ratings, :client_user, null: false, foreign_key: { to_table: :users }
    add_reference :ratings, :service_center, null: false, foreign_key: true
  end
end
