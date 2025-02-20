class ChangeDatatypeFreeDrinkOfFilters < ActiveRecord::Migration[8.0]
  def change
    change_column :filters, :free_drink, :integer
    change_column :filters, :free_food, :integer
    change_column :filters, :private_room, :integer
    change_column :filters, :course, :integer
    change_column :filters, :midnight, :integer
    change_column :filters, :non_smoking, :integer
  end
end
