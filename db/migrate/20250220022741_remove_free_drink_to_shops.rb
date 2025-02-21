class RemoveFreeDrinkToShops < ActiveRecord::Migration[8.0]
  def change
    remove_column :shops, :free_drink, :string
    remove_column :shops, :free_food, :string
    remove_column :shops, :private_room, :string
    remove_column :shops, :course, :string
    remove_column :shops, :midnight, :string
    remove_column :shops, :non_smoking, :string
    remove_column :shops, :sake, :integer
    remove_column :shops, :wine, :integer
    remove_column :shops, :shochu, :integer
    remove_column :shops, :cocktail, :integer
  end
end
