class Ride < ActiveRecord::Base
  belongs_to :user

  validates :origin, :destination, :total_seat, :user, presence: true

  scope :search_by_origin_destination, lambda { |origin, destination| where("origin = ? AND destination = ?", origin, destination).order("destination") }
  scope :search_by_destination, lambda { |destination| where("destination = ?", destination).order("destination") }
end