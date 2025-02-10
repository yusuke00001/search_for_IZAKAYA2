class AddUniqueNumberToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :unique_number, :integer
  end
end
