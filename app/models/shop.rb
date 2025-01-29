class Shop < ApplicationRecord
  has_many :bookmarks

  validates :name_of_shop, precense: true
end
