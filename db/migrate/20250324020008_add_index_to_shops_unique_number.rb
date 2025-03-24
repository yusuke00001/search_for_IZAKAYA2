class AddIndexToShopsUniqueNumber < ActiveRecord::Migration[8.0]
  def change
    add_index :shops, :unique_number, unique: true
  end
end
