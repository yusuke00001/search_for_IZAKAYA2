class RenameImageColumnToShops < ActiveRecord::Migration[8.0]
  def change
    rename_column :shops, :image, :logo_image
  end
end
