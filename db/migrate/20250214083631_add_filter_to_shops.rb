class AddFilterToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :free_drink, :integer
    add_column :shops, :free_food, :integer
    add_column :shops, :private_room, :integer
    add_column :shops, :course, :integer
    add_column :shops, :midnight, :integer
    add_column :shops, :non_smoking, :integer
    add_column :shops, :wine, :integer
    add_column :shops, :sake, :integer
    add_column :shops, :cocktail, :integer
    add_column :shops, :shochu, :integer
  end
end
