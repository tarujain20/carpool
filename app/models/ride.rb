class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :connections, :dependent => :destroy

  validates :origin, :destination, :total_seat, :user, :business_email, :business_name, :commute_days,
            :origin_address, :destination_address, :leave_at, :return_at, presence: true
  validates_format_of :business_email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z0-9.-]+\z/

  scope :search_by_origin_destination, lambda { |origin, destination| where("origin = ? AND destination = ?", origin, destination).order("destination") }
  scope :search_by_destination, lambda { |destination| where("destination = ?", destination).order("destination") }

  def status
    self.class.to_s.gsub("Ride", "")
  end
end