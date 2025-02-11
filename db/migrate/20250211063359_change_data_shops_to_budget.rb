class ChangeDataShopsToBudget < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :budget, :json
  end
end
