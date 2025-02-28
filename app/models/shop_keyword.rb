class ShopKeyword < ApplicationRecord
  belongs_to :shop
  belongs_to :keyword

  def self.find_or_create_association(shop, keyword)
    find_or_create_by!(shop_id: shop.id, keyword_id: keyword.id)
  end
end
