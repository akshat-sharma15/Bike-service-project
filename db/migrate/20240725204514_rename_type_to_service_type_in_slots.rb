class RenameTypeToServiceTypeInSlots < ActiveRecord::Migration[7.0]
  def change
    rename_column :slots, :type, :service_type
  end
end
