class ChangeKeywordDefaultToIzakaya < ActiveRecord::Migration[8.0]
  def change
    change_column_default :keywords, :word, from: nil, to: "居酒屋"
  end
end
