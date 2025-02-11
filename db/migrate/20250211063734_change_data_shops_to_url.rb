class ChangeDataShopsToUrl < ActiveRecord::Migration[8.0]
  def change
    change_column :shops, :url, :json
  end
end
