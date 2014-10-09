class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string "type"
      t.string "origin"
      t.string "destination"
      t.string "total_seat"
      t.date "date"
      t.timestamps
    end

    add_index "rides", "origin"
    add_index "rides", "destination"
  end
end
