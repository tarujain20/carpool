class Address < ActiveRecord::Base
  validates :address_1, :city, :state, presence: true
end