require 'rails_helper'

describe "User Rides", :type => :feature do
  after(:each) do
    page.driver.delete destroy_user_session_path
  end

  before(:each) do
    @user = User.create(:first_name => "Brad", :last_name => "Doe", :email => "test@example.com", :password => "password")
    @ride1 = RideOffer.create!(:origin => "San Jose", :destination => "Mountain View", :business_name => "Google", :business_email => "brad@google.com",
                               :origin_address => "7101 Rainbow Dr, San Jose, CA 95129", :destination_address => "1600 Amphitheatre Parkway, Mountain View, CA 94043",
                               :total_seat => 1, :user => @user, :commute_days => "MWF")
  end

  describe "existing user" do
    before(:each) do
      visit new_user_session_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "password"

      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
    end

    context "new ride request" do
      it "is successful" do
        click_link "create_new_ride"

        choose "ride_type_rideoffer"
        fill_in "ride_origin", :with => "San Jose"
        fill_in "ride_origin_address", :with => "111 Happy Way"
        fill_in "ride_destination", :with => "Sunnyvale"
        fill_in "ride_destination_address", :with => "123 Some ln"
        fill_in "ride_business_name", :with => "Intel"
        fill_in "ride_business_email", :with => "345 Some Dr"
        fill_in "ride_total_seat", :with => "1"
        click_button "Submit"

        expect(page).to have_content("Successfully added ride.")
      end
    end

    context "search for ride" do
      before(:each) do
        @user2 = User.create(:first_name => "Jen", :last_name => "Doe", :email => "test@example.com", :password => "password")
        @ride2 = RideOffer.create!(:origin => "San Jose", :destination => "Sunnyvale", :business_name => "Intel", :business_email => "jen@intel.com",
                                   :origin_address => "7101 Mary Dr, San Jose, CA 95129", :destination_address => "1600 Some Parkway, Sunnyvale, CA",
                                   :total_seat => 1, :user => @user2, :commute_days => "MWF")

        fill_in "ride_origin", :with => "San Jose"
        fill_in "ride_destination", :with => "Sunnyvale"
        click_button "Search"
      end

      it "shows the result with all the correct values" do
        expect(page).to have_content(@ride2.origin)
        expect(page).to have_content(@ride2.destination)
        expect(page).to have_content(@ride2.business_name)
        expect(page).to have_content(@ride2.status)
        expect(page).to have_content(@ride2.total_seat)
      end

      it "does NOT show business email of the person offering ride" do
        expect(page).not_to have_content("jen@intel.com")
      end
    end

    context "my rides" do
      it "shows all requests/offered rides of the signed in user" do
        click_link "My Rides"
        expect(page).to have_content(@ride1.origin)
        expect(page).to have_content(@ride1.destination)
        expect(page).to have_content(@ride1.business_name)
        expect(page).to have_content(@ride1.status)
        expect(page).to have_content(@ride1.total_seat)
        expect(page).to have_content("Edit")
        expect(page).to have_content("Delete")
      end
    end
  end
end
