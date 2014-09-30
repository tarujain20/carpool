class Address < ActiveRecord::Base
  validates :city, presence: true
end