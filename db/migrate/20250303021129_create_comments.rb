class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.date :visit_day
      t.integer :value
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :shop, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }, type: :integer
      t.timestamps
    end
  end
end
