class ModifyRides < ActiveRecord::Migration
  def change
    add_column :rides, :business_name, :string
    add_column :rides, :business_email, :string
    add_column :rides, :verified_business_email, :boolean, :default => false, :null => false

    add_index "rides", %w[origin destination]
  end
end
