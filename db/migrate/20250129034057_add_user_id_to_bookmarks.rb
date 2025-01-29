class AddUserIdToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_column :bookmarks, :user_id, :bigint
  end
end
