class UserMailer < ActionMailer::Base
  default :from => "Commute Up <support@commuteup.com>"

  def verify_work_email(ride_id)
    find_models(ride_id)
    mail(:to => @business_email, :subject => "Verify your work email to find carpool via CommuteUp!")
  end

  def send_connection_request(connection_id)
    @connection = Connection.where(:id => connection_id).take
    ride_id = @connection.ride_id
    find_models(ride_id)
    mail(:to => @business_email, :cc => @user.email, :subject => "Carpool request via CommuteUp!")
  end

  def send_connection_request_receipt(ride_id, user_id)
    @current_user = User.where(:id => user_id).take
    @ride = Ride.where(:id => ride_id).take
    @first_name = @current_user.first_name
    mail(:to => @current_user.email, :subject => "Receipt of carpool request via CommuteUp!")
  end

  private

  def find_models(ride_id)
    @ride = Ride.where(:id => ride_id).take
    @business_email = @ride.business_email
    @user = @ride.user
    @first_name = @user.first_name
  end
end