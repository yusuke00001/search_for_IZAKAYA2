class CreateKeywordFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :keyword_filters do |t|
      t.references :keyword, null: false, foreign_key: { on_update: :cascade, on_dalete: :cascade }
      t.references :filter, null: false, foreign_key: { on_update: :cascade, on_dalete: :cascade }
      t.timestamps
    end
  end
end
