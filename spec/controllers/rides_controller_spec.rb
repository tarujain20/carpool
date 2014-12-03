require 'rails_helper'

describe RidesController, :type => :controller do
  before(:each) do
    @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
    sign_in(@user)
    @ride1 = RideOffer.create!(:origin => "San Jose", :destination => "Mountain View", :business_name => "Google", :business_email => "julia@google.com",
                               :origin_address => "7101 Rainbow Dr, San Jose, CA 95129", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                               :total_seat => 1, :user => @user, :commute_days => "MWF", :leave_at => "9:00 am", :return_at => "7:00 pm")

    @user2 = User.create!(:first_name => "Bob", :last_name => "R", :email => "bob@example.com", :password => "password", :password_confirmation => "password")
    @ride2 = RideRequest.create!(:origin => "San Francisco", :destination => "Mountain View", :business_name => "Google", :business_email => "bob@google.com",
                                 :origin_address => "7101 Main Dr, San Francisco, CA", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                                 :total_seat => 1, :user => @user2, :commute_days => "MTWThF", :leave_at => "8:00 am", :return_at => "5:00 pm")

    @user3 = User.create!(:first_name => "John", :last_name => "Doe", :email => "jdoe@example.com", :password => "password", :password_confirmation => "password")
    @ride3 = RideRequest.create!(:origin => "San Jose", :destination => "Mountain View", :business_name => "LinkedIn", :business_email => "jdoe@linkedin.com",
                                 :origin_address => "7101 Miller Dr, San Jose, CA 95129", :destination_address => "1600 Main Dr, Mountain View, CA 94043",
                                 :total_seat => 1, :user => @user3, :commute_days => "MWF", :leave_at => "8:00 am", :return_at => "5:00 pm")
  end

  describe "index" do
    it "shows logged in users ride (offered or requested)" do
      get :index
      expect(response).to be_success
      expect(assigns(:rides).to_a).to eq([@ride1])
    end
  end

  describe "search" do
    it "shows all available rides" do
      get :search, :ride => {:origin => "San Jose", :destination => "Mountain View"}

      expect(response).to be_success
      expect(assigns(:rides).to_a).to eq([@ride1, @ride3])
      assert_select "div#available_rides"
      assert_select "tr#ride_#{@ride1.id}"
    end

    context "no origin entered" do
      it "shows all available rides going to the destination" do
        get :search, :ride => {:destination => "Mountain View"}

        expect(response).to be_success
        expect(assigns(:rides).to_a).to eq([@ride1, @ride2, @ride3])
      end
    end
  end

  describe "#new" do
    it "show the form" do
      get :new
      expect(response).to be_success
      expect(assigns[:ride]).to be_new_record
    end
  end

  describe "create" do
    context "Request a Ride" do
      it "creates new RideRequest" do
        expect do
          post :create, :ride => {:type => "RideRequest", :origin => "San Jose", :destination => "Santa Clara",
                                  :origin_address => "111 Some Ln, San Jose, CA", :destination_address => "234 Happy Dr, Santa Clara, CA",
                                  :business_name => "Intel", :business_email => "s@intel.com", :total_seat => 1,
                                  :leave_at => "8:00 am", :return_at => "5:00 pm"},
               :commute_days => ["M", "W", "F"]

        end.to change(RideRequest, :count).by(1)
        expect(response).to redirect_to(rides_url(:ride => {:destination => "Santa Clara"}))
      end
    end

    context "Offer a Ride" do
      it "creates new RideOffer" do
        expect do
          post :create, :ride => {:type => "RideOffer", :origin => "San Jose", :destination => "Sunnyvale", :total_seat => 1,
                                  :business_name => "Yahoo", :business_email => "s@yahoo.com",
                                  :origin_address => "111 Some Ln, San Jose, CA", :destination_address => "234 Mary Dr, Sunnyvale, CA",
                                  :leave_at => "8:00 am", :return_at => "5:00 pm"},
               :commute_days => ["M", "W"]
        end.to change(RideOffer, :count).by(1)
        ride = RideOffer.last
        expect(ride.commute_days).to eq("M W")
        expect(response).to redirect_to(rides_url(:ride => {:destination => "Sunnyvale"}))
      end
    end

    it "show form with errors" do
      expect do
        post :create, :ride => {:type => "RideRequest", :origin => "", :destination => "Intel HQ", :total_seat => 1}
      end.not_to change(Ride, :count)
      expect(response).to render_template(:new)
    end
  end

  describe "member actions" do
    describe "edit" do
      it "shows the edit form" do
        get :edit, :id => @ride1.to_param
        expect(response).to be_success
        expect(assigns[:ride]).to eq(@ride1)
        assert_select "form input#ride_origin"
      end
    end

    describe "update" do
      it "updates the ride" do
        put :update, :id => @ride1.to_param, :ride => {:type => "RideOffer", :origin => "Fremont", :destination => "Santa Clara", :total_seat => 2},
            :commute_days => ["M", "W"]
        expect(response).to redirect_to(rides_url)
        expect(@ride1.reload.origin).to eq("Fremont")
      end

      it "shows form with errors" do
        put :update, :id => @ride1.to_param, :ride => {:type => "RideOffer", :origin => "", :destination => "Santa Clara", :total_seat => 1},
            :commute_days => ["M", "W"]
        expect(response).to render_template(:edit)
      end
    end

    describe "destroy" do
      it "deletes the procedure" do
        expect do
          delete :destroy, :id => @ride1.to_param
        end.to change(RideOffer, :count).by(-1)
        expect(response).to redirect_to(rides_url)
      end
    end
  end
end