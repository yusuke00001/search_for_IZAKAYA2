class AddColumnShops < ActiveRecord::Migration[8.0]
  def change
    add_column :shops, :address, :text
    add_column :shops, :phone_number, :integer
    add_column :shops, :access, :string
    add_column :shops, :opening_hours, :string
    add_column :shops, :closing_day, :string
    add_column :shops, :budget, :string
    add_column :shops, :number_of_seats, :string
    add_column :shops, :url, :text
  end
end
