class Shop < ApplicationRecord
  has_many :bookmarks
  has_many :shop_keywords
  has_many :keywords, through: :shop_keywords, dependent: :destroy
  has_many :comments
  belongs_to :filter

  validates :name, presence: true
  validates :unique_number, uniqueness: true

  PAGE_NUMBER = 10
  DISPLAY_PAGE_RUNGE = 3

  def self.upsert_from_API_data(shops_data)
    # upsert_allを使うことでデータが存在していたら更新、なければ新規登録
    upsert_all(shops_data)
  end

  def self.filter_and_keyword_association(filters, keyword)
    joins(:filter, :keywords)
    .where(filters: { id: filters.ids },
           keywords: { id: keyword.id })
  end
end
