class AddFilterIdToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :filter_id, :bigint
  end
end
