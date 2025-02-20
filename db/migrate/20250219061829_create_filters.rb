class CreateFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :filters do |t|
      t.string :free_drink
      t.string :free_food
      t.string :private_room
      t.string :course
      t.string :midnight
      t.string :non_smoking
      t.references :keyword, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :shop, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }, type: :integer

      t.timestamps
    end
  end
end
