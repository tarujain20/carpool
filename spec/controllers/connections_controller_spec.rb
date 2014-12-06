require 'rails_helper'

describe ConnectionsController, :type => :controller do
  before(:each) do
    @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
    sign_in(@user)

    @user2 = User.create!(:first_name => "Bob", :last_name => "R", :email => "bob@example.com", :password => "password", :password_confirmation => "password")
    @ride2 = RideRequest.create!(:origin => "San Francisco", :destination => "Mountain View", :business_name => "Google", :business_email => "bob@google.com",
                                 :origin_address => "7101 Main Dr, San Francisco, CA", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                                 :total_seat => 1, :user => @user2, :commute_days => "MTWThF", :leave_at => "8:00 am", :return_at => "5:00 pm")

  end

  describe "index" do
    it "shows logged in users connections" do
      @connection = Connection.create!(:user_id => @user.id, :ride_id => @ride2.id)

      get :index
      expect(response).to be_success
      expect(assigns(:connections).to_a).to eq([@connection])
    end
  end

  describe "create" do
    it "creates a new connection" do
      expect do
        post :create, :connection => { :ride_id => @ride2.to_param }
      end.to change(Connection, :count).by(1)
      expect(response).to redirect_to(connections_path)
      expect(assigns[:connection]).to be_present
      expect(assigns[:connection].accept).to be_falsey
      expect(assigns[:connection].user_id).to eq @user.id
    end
  end
end