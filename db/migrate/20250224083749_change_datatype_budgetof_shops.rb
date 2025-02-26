class ChangeDatatypeBudgetofShops < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :budget, :string
    change_column :shops, :image, :text
    change_column :shops, :url, :text
  end
end
