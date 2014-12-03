class UserMailer < ActionMailer::Base
  default :from => "Commute Up <support@commuteup.com>"

  def verify_work_email(ride_id)
    @ride = Ride.where(:id => ride_id).take
    @email = @ride.business_email
    @first_name = @ride.user.first_name

    mail(:to => @email, :subject => "Verify your work email to find carpool via CommuteUp!")
  end
end