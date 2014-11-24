class RemoveDateFromRides < ActiveRecord::Migration
  def change
    remove_column :rides, :date
  end
end
