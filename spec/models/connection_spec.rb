require 'rails_helper'

describe Connection, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:ride) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:ride_id) }

  before(:each) do
    @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")

    @user2 = User.create!(:first_name => "Bob", :last_name => "R", :email => "bob@example.com", :password => "password", :password_confirmation => "password")
    @ride2 = RideRequest.create!(:origin => "San Francisco", :destination => "Mountain View", :business_name => "Google", :business_email => "bob@google.com",
                                 :origin_address => "7101 Main Dr, San Francisco, CA", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                                 :total_seat => 1, :user => @user2, :commute_days => "MTWThF", :leave_at => "8:00 am", :return_at => "5:00 pm")
  end

  describe "status" do


    context "accepted" do
      it "shows the driver business email if accepted" do
        @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)
        expect(@connection.status).to eq("Pending Approval by driver")
        @connection.accept = true
        @connection.save!
        expect(@connection.status).to eq("Contact Bob R at bob@google.com")
      end
    end
  end

  describe "after_create" do
    it "sends connection email" do
      mail = double("Mail")
      expect(UserMailer).to receive(:send_connection_request).with(anything).once.and_return(mail)
      expect(mail).to receive(:deliver).once
      @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)
    end

    it "send connection receipt email" do
      mail = double("Mail")
      expect(UserMailer).to receive(:send_connection_request_receipt).with(anything, anything).once.and_return(mail)
      expect(mail).to receive(:deliver).once
      @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)
    end
  end
end