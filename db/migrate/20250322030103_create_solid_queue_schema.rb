class CreateSolidQueueSchema < ActiveRecord::Migration[7.1]  # ← 自分のバージョンに合わせて！
  def change
    load Rails.root.join("db/queue_schema.rb")
  end
end
