class ShopKeyword < ApplicationRecord
  belongs_to :shop
  belongs_to :keyword

  validates :shop_id, uniqueness: { scope: :keyword_id } # shop_idとkeyword_idの組み合わせの重複拒否
end
