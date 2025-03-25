class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  validates :content, presence: true
  validates :value, presence: true

  validate :data_before_today

  def validate_data_before_today
    return if visit_day <= Date.today
      errors.add(:visit_day, "は今日以前の日付を選択してください")
  end
end
