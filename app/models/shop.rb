class Shop < ApplicationRecord
  has_many :bookmarks
  has_many :shop_keywords
  has_many :keywords, through: :shop_keywords, dependent: :destroy
  belongs_to :filter

  validates :name, presence: true
  validates :unique_number, uniqueness: true

  PAGE_NUMBER = 10
end
