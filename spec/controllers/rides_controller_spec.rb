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
        get :index, :ride => { :origin => "San Jose", :destination => "North Fork" }

        expect(response).to be_success
        expect(assigns(:rides).to_a).to eq([@ride1])
        assert_select "div#available_rides"
      end
    end

    context "no origin entered" do
      it "shows all available rides in future going to the destination" do
        get :index, :ride => { :destination => "North Fork" }

        expect(response).to be_success
        expect(assigns(:rides).to_a).to eq([@ride1, @ride2])
      end
    end
  end
end