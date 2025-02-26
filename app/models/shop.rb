class Shop < ApplicationRecord
  has_many :bookmarks
  has_many :shop_keywords
  has_many :keywords, through: :shop_keywords, dependent: :destroy
  belongs_to :filter

  validates :name, presence: true
  validates :unique_number, uniqueness: true
  validates :url, format: { with: /\Ahttps?:\/\/[\S]+\z/ }

  PAGE_NUMBER = 10
end
