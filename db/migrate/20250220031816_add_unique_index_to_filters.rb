class AddUniqueIndexToFilters < ActiveRecord::Migration[8.0]
  def change
    add_index :filters, [ :free_drink, :free_food, :private_room, :course, :midnight, :non_smoking ], unique: true
  end
end
