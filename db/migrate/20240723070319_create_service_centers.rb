class CreateServiceCenters < ActiveRecord::Migration[7.0]
  def change
    create_table :service_centers do |t|
      t.string :name
      t.string :location
      t.string :revanue

      t.timestamps
    end
  end
end
