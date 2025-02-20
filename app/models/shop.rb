class Shop < ApplicationRecord
  has_many :bookmarks
  has_many :shop_filters
  has_many :filters, through: :shop_filters, dependent: :destroy
  has_many :shop_keywords
  has_many :keywords, through: :shop_keywords, dependent: :destroy

  validates :name, presence: true
  validates :unique_number, uniqueness: true

  PAGE_NUMBER = 10
end
