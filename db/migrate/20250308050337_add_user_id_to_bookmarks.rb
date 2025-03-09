class AddUserIdToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_column :bookmarks, :user_id, :bigint
    add_column :bookmarks, :shop_id, :integer
  end
end
