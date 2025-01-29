class AddShopIdToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_column :bookmarks, :shop_id, :bigint
  end
end
