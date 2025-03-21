class ShopKeyword < ApplicationRecord
  belongs_to :shop
  belongs_to :keyword

  def self.bulk_insert(shop_keyword_data)
    insert_all(shop_keyword_data)
  end
end
