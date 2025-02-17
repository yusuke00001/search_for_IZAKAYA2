class RemoveKeywordsToShops < ActiveRecord::Migration[8.0]
  def change
    remove_column :shops, :keywords
  end
end
