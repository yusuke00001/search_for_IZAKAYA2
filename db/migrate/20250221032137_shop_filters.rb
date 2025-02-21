class ShopFilters < ActiveRecord::Migration[8.0]
  def change
    drop_table :shop_filters
  end
end
