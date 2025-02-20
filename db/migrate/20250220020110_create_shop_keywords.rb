class CreateShopKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :shop_keywords do |t|
      t.references :shop, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }, type: :integer
      t.references :keyword, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end
end
