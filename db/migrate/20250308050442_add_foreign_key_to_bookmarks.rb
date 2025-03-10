class AddForeignKeyToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :bookmarks, :shops, column: :shop_id, on_update: :cascade, on_delete: :cascade
    add_foreign_key :bookmarks, :users, column: :user_id, on_update: :cascade, on_delete: :cascade
  end
end
