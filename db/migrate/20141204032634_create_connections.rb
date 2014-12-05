class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer "user_id"
      t.integer "ride_id"
      t.timestamps
    end
  end
end
