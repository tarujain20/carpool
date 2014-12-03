class AddCommuteTimesToRide < ActiveRecord::Migration
  def change
    add_column :rides, :leave_at, :string
    add_column :rides, :return_at, :string
  end
end
