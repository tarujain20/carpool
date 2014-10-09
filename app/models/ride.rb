class Ride < ActiveRecord::Base
  validates :origin, :destination, :total_seat, :date, presence: true
end