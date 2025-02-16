class RenameNemeOfShopToShops < ActiveRecord::Migration[8.0]
  def change
    rename_column :shops, :name_of_shop, :name
  end
end
