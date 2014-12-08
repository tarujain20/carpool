require 'rails_helper'

describe UserMailer, :type => :mailer do
  before(:each) do
    @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
    @ride1 = RideOffer.create!(:origin => "San Jose", :destination => "Mountain View", :business_name => "Google", :business_email => "julia@google.com",
                               :origin_address => "7101 Rainbow Dr, San Jose, CA 95129", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                               :total_seat => 1, :user => @user, :commute_days => "MWF", :leave_at => "9:00 am", :return_at => "7:00 pm")

  end

  describe "verify_work_email" do
    it "sends link to verify work email" do
      expect {
        @sent = UserMailer.verify_work_email(@ride1.id).deliver
      }.to change(ActionMailer::Base.deliveries, :length).by(1)

      expect(@sent.from).to eq(["support@commuteup.com"])
      expect(@sent.to).to eq([@ride1.business_email])
      expect(@sent.subject).to eq("Verify your work email to find carpool via CommuteUp!")
      expect(@sent.body).to include(@user.first_name)
    end
  end

  context "connection emails" do
    before(:each) do
      @user2 = User.create!(:first_name => "Bob", :last_name => "R", :email => "bob@example.com", :password => "password", :password_confirmation => "password")
      @ride2 = RideRequest.create!(:origin => "San Francisco", :destination => "Mountain View", :business_name => "Google", :business_email => "bob@google.com",
                                   :origin_address => "7101 Main Dr, San Francisco, CA", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                                   :total_seat => 1, :user => @user2, :commute_days => "MTWThF", :leave_at => "8:00 am", :return_at => "5:00 pm")
      @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)
    end

    describe "send_connection_request" do
      it "sends link to verify work email" do
        expect {
          @sent = UserMailer.send_connection_request(@connection.id).deliver
        }.to change(ActionMailer::Base.deliveries, :length).by(1)

        expect(@sent.from).to eq(["support@commuteup.com"])
        expect(@sent.to).to eq([@ride2.business_email])
        expect(@sent.subject).to eq("Carpool request via CommuteUp!")
        expect(@sent.body).to include(@user2.first_name)
      end
    end


    describe "send_connection_request_receipt" do
      it "sends link to verify work email" do
        expect {
          @sent = UserMailer.send_connection_request_receipt(@ride2.id, @user.id).deliver
        }.to change(ActionMailer::Base.deliveries, :length).by(1)

        expect(@sent.from).to eq(["support@commuteup.com"])
        expect(@sent.to).to eq([@user.email])
        expect(@sent.subject).to eq("Receipt of carpool request via CommuteUp!")
        expect(@sent.body).to include(@user.first_name)
      end
    end
  end
end