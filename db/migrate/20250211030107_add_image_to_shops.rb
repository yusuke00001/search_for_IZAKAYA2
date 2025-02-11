class AddImageToShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :image, :text
  end
end
