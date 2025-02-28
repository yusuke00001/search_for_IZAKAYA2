class RemoveWineToFilters < ActiveRecord::Migration[8.0]
  def change
    remove_column :filters, :wine, :integer
    remove_column :filters, :sake, :integer
    remove_column :filters, :cocktail, :integer
    remove_column :filters, :shochu, :integer
  end
end
