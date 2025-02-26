class KeywordFilter < ApplicationRecord
  belongs_to :keyword
  belongs_to :filter

  def self.find_or_create_association(keyword, filter)
    KeywordFilter.find_or_create_by!(keyword_id: keyword.id, filter_id: filter.id)
  end
end
