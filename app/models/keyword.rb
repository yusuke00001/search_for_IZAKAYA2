class Keyword < ApplicationRecord
  has_many :keyword_filters
  has_many :filters, through: :keyword_filters, dependent: :destroy
  has_many :shop_keywords
  has_many :shops, through: :shop_keywords, dependent: :destroy

  validates :word, uniqueness: true

  def self.find_or_create_keyword(keyword)
    find_or_create_by!(word: keyword)
  end
end
