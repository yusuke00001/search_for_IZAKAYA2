class ShopKeywords < ActiveRecord::Migration[8.0]
  def change
    drop_table :shop_keywords
  end
end
