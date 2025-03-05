class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  validates :content, presence: true
  validates :value, presence: true
end
