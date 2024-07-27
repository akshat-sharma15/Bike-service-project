class AddReferenceOfServiceCenterToBike < ActiveRecord::Migration[7.0]
  def change
    add_reference :bikes, :service_center, null: false, foreign_key: true
  end
end
