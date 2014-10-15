class Ride < ActiveRecord::Base
  validates :origin, :destination, :total_seat, :date, presence: true

  scope :search_by_origin_destination, lambda { |origin, destination| where("origin = ? AND destination = ? AND date > ?", origin, destination, Time.now).order("date") }
  scope :search_by_destination, lambda { |destination| where("destination = ? AND date > ?", destination, Time.now).order("date") }
end