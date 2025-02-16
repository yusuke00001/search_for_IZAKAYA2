class Keyword < ApplicationRecord
  has_many :shop_keywords
  has_many :shops, through: :shop_keywords

  validates :word, uniqueness: true
end
