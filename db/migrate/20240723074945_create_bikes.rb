class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.string :info
      t.string :regstration_num
      t.string :status
      t.string :service

      t.timestamps
    end
  end
end
