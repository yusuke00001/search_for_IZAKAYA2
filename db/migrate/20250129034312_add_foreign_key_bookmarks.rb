class AddForeignKeyBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :bookmarks, :users, column: :user_id
    add_foreign_key :bookmarks, :shops, column: :shop_id
  end
end
