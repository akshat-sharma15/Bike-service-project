class AddColumnRateToBike < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :rate, :string
  end
end
