class KeywordFilter < ApplicationRecord
  belongs_to :keyword
  belongs_to :filter

  def self.find_association(keyword, filter)
    find_by(keyword_id: keyword.id, filter_id: filter.id)
  end
  def self.find_or_create_association(keyword, filter)
    find_or_create_by!(keyword_id: keyword.id, filter_id: filter.id)
  end
end
