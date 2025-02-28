class Filter < ApplicationRecord
  has_many :keyword_filters
  has_many :keyword, through: :keyword_filters, dependent: :destroy
  has_many :shops

  validates :free_drink, uniqueness: { scope: [ :free_food, :private_room, :course, :midnight, :non_smoking ] }

  def self.find_or_create(filter)
    find_or_create_by!(filter)
  end
end
