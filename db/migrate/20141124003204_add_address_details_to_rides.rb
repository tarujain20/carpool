class AddAddressDetailsToRides < ActiveRecord::Migration
  def change
    add_column :rides, :origin_address, :string
    add_column :rides, :destination_address, :string
  end
end
