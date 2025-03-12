class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  validates :user_id, uniqueness: { scope: [ :shop_id ] }

  PAGE_NUMBER = 10
  DISPLAY_PAGE_RUNGE = 3
end
