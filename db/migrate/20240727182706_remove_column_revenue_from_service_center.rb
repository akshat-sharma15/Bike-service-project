class RemoveColumnRevenueFromServiceCenter < ActiveRecord::Migration[7.0]
  def change
    remove_column :service_centers, :revanue, :string
  end
end
