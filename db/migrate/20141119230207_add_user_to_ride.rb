class AddUserToRide < ActiveRecord::Migration
  def change
    add_column :rides, :user_id, :integer

    add_index "rides", %w[user_id]
  end
end
