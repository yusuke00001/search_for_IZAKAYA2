class ChangeDataUniqueNumberToShops < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :unique_number, :string
  end
end
