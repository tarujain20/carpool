require 'rails_helper'

describe Connection, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:ride) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:ride_id) }
  it { should validate_uniqueness_of(:ride_id).scoped_to(:user_id).with_message("You already connected with this ride. If there is no response yet please search again and find another ride.") }

  describe "status" do
    before(:each) do
      @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")

      @user2 = User.create!(:first_name => "Bob", :last_name => "R", :email => "bob@example.com", :password => "password", :password_confirmation => "password")
      @ride2 = RideRequest.create!(:origin => "San Francisco", :destination => "Mountain View", :business_name => "Google", :business_email => "bob@google.com",
                                   :origin_address => "7101 Main Dr, San Francisco, CA", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                                   :total_seat => 1, :user => @user2, :commute_days => "MTWThF", :leave_at => "8:00 am", :return_at => "5:00 pm")
    end

    context "accepted" do
      it "shows the driver business email" do
        @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id, :accept => true)
        expect(@connection.status).to eq("Contact Bob R at bob@google.com")
      end
    end

    context "not accepted by user" do
      it "shows the Pending message" do
        @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)
        expect(@connection.status).to eq("Pending Approval by driver")
      end
    end
  end
end