class AddCommuteDaysToRide < ActiveRecord::Migration
  def change
    add_column :rides, :commute_days, :string
  end
end
