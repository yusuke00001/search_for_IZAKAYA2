class Shop < ApplicationRecord
  has_many :bookmarks

  validates :name_of_shop, presence: true
  validates :unique_number, uniqueness: true

  PAGE_NUMBER = 10
end
