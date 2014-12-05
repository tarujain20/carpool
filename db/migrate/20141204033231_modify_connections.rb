class ModifyConnections < ActiveRecord::Migration
  def change
    add_column :connections, :accept, :boolean, :default => false, :null => false
  end
end
