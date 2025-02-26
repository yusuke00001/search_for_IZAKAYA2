class Filter < ApplicationRecord
  has_many :keyword_filters
  has_many :keyword, through: :keyword_filters, dependent: :destroy
  has_many :shops

  validates :free_drink, uniqueness: { scope: [ :free_food, :private_room, :course, :midnight, :non_smoking ] }

  def self.filter_find_or_create
    Filter.find_or_create_by!(search_condition)
  end
  def self.filter_create(free_drink, free_food, private_room, course, midnight, non_smoking)
    Filter.find_or_create_by!(
        free_drink: free_drink,
        free_food: free_food,
        private_room: private_room,
        course: course,
        midnight: midnight,
        non_smoking: non_smoking
    )
  end
end
