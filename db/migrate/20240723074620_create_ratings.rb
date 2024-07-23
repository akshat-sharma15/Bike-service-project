class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.string :star
      t.string :comments

      t.timestamps
    end
  end
end
