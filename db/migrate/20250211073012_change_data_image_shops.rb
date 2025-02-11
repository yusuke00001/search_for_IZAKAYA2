class ChangeDataImageShops < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :image, :json
  end
end
