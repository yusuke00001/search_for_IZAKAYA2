class CreateShopFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :shop_filters do |t|
      t.references :shop, null: false, foreign_key: { on_update: :cascade, on_dalete: :cascade }, type: :integer
      t.references :filter, null: false, foreign_key: { on_update: :cascade, on_dalete: :cascade }
      t.timestamps
    end
  end
end
