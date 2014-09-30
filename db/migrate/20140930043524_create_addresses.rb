class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string "address_1"
      t.string "address_2"
      t.string "city"
      t.string "state"
      t.string "country"
      t.timestamps
    end

    add_index "addresses", "city"
    add_index "addresses", "state"
  end
end
