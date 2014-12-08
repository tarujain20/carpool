class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride

  validates :user_id, :ride_id, presence: true
  validates_uniqueness_of :ride_id, :scope => :user_id,
                          :message => "You already connected with this ride. If there is no response yet please search again and find another ride."

  after_create :send_emails

  def status
    self.accept? ? "Contact #{ride.user.full_name} at #{ride.business_email}" : "Pending Approval by driver"
  end

  def send_emails
    UserMailer.send_connection_request(self.id).deliver
    UserMailer.send_connection_request_receipt(self.ride_id, user_id).deliver
  end
end