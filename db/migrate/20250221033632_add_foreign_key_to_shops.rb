class AddForeignKeyToShops < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :shops, :filters, column: :filter_id, on_update: :cascade, on_delete: :cascade
  end
end
