class Shop < ApplicationRecord
  has_many :bookmarks

  validates :name_of_shop, presence: true

  def self.page_number
    10
  end
end
