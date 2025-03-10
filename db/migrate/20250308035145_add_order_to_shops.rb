class AddOrderToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :order, :integer
  end
end
