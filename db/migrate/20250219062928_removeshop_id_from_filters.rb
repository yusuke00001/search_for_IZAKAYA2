class RemoveshopIdFromFilters < ActiveRecord::Migration[8.0]
  def change
    remove_column :filters, :shop_id, :integer
    remove_column :filters, :keyword_id, :bigint
  end
end
