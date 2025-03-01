class Shop < ApplicationRecord
  has_many :bookmarks
  has_many :shop_keywords
  has_many :keywords, through: :shop_keywords, dependent: :destroy
  belongs_to :filter

  validates :name, presence: true
  validates :unique_number, uniqueness: true

  def self.create_or_update_from_API_data(shop_data, filter)
    shop = find_by(unique_number: shop_data["id"])
    if shop
      shop.update!(
        name: shop_data["name"],
        address: shop_data["address"],
        phone_number: shop_data["tel"],
        access: shop_data["access"],
        closing_day: shop_data["close"],
        budget: shop_data.dig("budget", "average"),
        number_of_seats: shop_data["capacity"],
        url: shop_data.dig("urls", "pc"),
        logo_image: shop_data["logo_image"],
        image: shop_data.dig("photo", "pc", "l")
      )
      shop
    else
      shop = create!(
        unique_number: shop_data["id"],
        name: shop_data["name"],
        address: shop_data["address"],
        phone_number: shop_data["tel"],
        access: shop_data["access"],
        closing_day: shop_data["close"],
        budget: shop_data.dig("budget", "average"),
        number_of_seats: shop_data["capacity"],
        url: shop_data.dig("urls", "pc"),
        logo_image: shop_data["logo_image"],
        image: shop_data.dig("photo", "pc", "l"),
        filter_id: filter.id
      )
    end
  end
  def self.filter_or_keyword_association(filters, keyword)
    joins(:filter, :keywords)
    .where(filters: { id: filters.ids },
           keywords: { id: keyword.id })
  end
end
