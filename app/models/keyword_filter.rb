class KeywordFilter < ApplicationRecord
  belongs_to :keyword
  belongs_to :filter
end
