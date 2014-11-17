require 'rails_helper'

describe RidesController, :type => :controller do
  before(:each) do
    @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
    sign_in(@user)
    @ride1 = RideOffer.create!(:origin => "San Jose", :destination => "North Fork", :total_seat => 1, :date => 1.day.from_now.to_date)
    @ride2 = RideOffer.create!(:origin => "San Francisco", :destination => "North Fork", :total_seat => 1, :date => 2.day.from_now.to_date)
    @ride3 = RideOffer.create!(:origin => "San Jose", :destination => "Kelseyville", :total_seat => 1, :date => 7.day.from_now.to_date)
  end

  describe "index" do
    context "no date entered" do
      it "shows all available rides in future" do
        get :index, :ride => {:origin => "San Jose", :destination => "North Fork"}

        expect(response).to be_success
        expect(assigns(:rides).to_a).to eq([@ride1])
        assert_select "div#available_rides"
      end
    end

    context "no origin entered" do
      it "shows all available rides in future going to the destination" do
        get :index, :ride => {:destination => "North Fork"}

        expect(response).to be_success
        expect(assigns(:rides).to_a).to eq([@ride1, @ride2])
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
          post :create, :ride => {:type => "RideRequest", :origin => "San Jose", :destination => "Intel HQ", :total_seat => 1, :date => 2.day.from_now.to_date}
        end.to change(RideRequest, :count).by(1)
        expect(response).to redirect_to(rides_url(:ride => {:destination => "Intel HQ"}))
      end
    end

    context "Offer a Ride" do
      it "creates new RideOffer" do
        expect do
          post :create, :ride => {:type => "RideOffer", :origin => "San Jose", :destination => "Intel HQ", :total_seat => 1, :date => 2.day.from_now.to_date}
        end.to change(RideOffer, :count).by(1)
        expect(response).to redirect_to(rides_url(:ride => {:destination => "Intel HQ"}))
      end
    end

    it "show form with errors" do
      expect do
        post :create, :ride => {:type => "RideRequest", :origin => "", :destination => "Intel HQ", :total_seat => 1, :date => 2.day.from_now.to_date}
      end.not_to change(Ride, :count)
      expect(response).to render_template(:new)
    end
  end
end