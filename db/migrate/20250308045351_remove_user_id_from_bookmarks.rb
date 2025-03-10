class RemoveUserIdFromBookmarks < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :bookmarks, :users
    remove_foreign_key :bookmarks, :shops
    remove_column :bookmarks, :user_id, :bigint
    remove_column :bookmarks, :shop_id, :bigint
  end
end
