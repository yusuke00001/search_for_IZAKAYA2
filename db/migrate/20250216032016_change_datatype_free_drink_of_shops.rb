class ChangeDatatypeFreeDrinkOfShops < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :free_drink, :string
    change_column :shops, :free_food, :string
    change_column :shops, :private_room, :string
    change_column :shops, :course, :string
    change_column :shops, :midnight, :string
    change_column :shops, :non_smoking, :string
  end
end
