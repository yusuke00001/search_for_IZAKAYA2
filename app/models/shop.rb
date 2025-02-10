class Shop < ApplicationRecord
  has_many :bookmarks

  validates :name_of_shop, presence: true
  validates :unique_number, uniqueness: true
  def self.page_number
    10
  end
end
