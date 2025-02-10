class AddforeignKeyToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :bookmarks, :shops, column: :shop_id
  end
end
