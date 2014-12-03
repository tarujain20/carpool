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

      # expect(@sent.body).to include(%Q[<a href="#{signup_url(invitation, :host => 'test.host')}">])
    end
  end
end