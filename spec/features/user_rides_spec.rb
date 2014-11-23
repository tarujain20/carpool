require 'rails_helper'

describe "User Rides", :type => :feature do
  after(:each) do
    page.driver.delete destroy_user_session_path
  end

  before(:each) do
    @user = User.create(:first_name => "Brad", :last_name => "Doe", :email => "test@example.com", :password => "password")
    @ride1 = RideOffer.create!(:origin => "San Jose", :destination => "Mountain View", :business_name => "Google", :business_email => "brad@google.com",
                               :total_seat => 1, :user => @user)
  end

  describe "existing user" do
    before(:each) do
      visit new_user_session_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "password"

      click_button "Log in"
      expect(page).to have_content("Signed in successfully.")
    end

    context "search for ride" do
      before(:each) do
        @user2 = User.create(:first_name => "Jen", :last_name => "Doe", :email => "test@example.com", :password => "password")
        @ride2 = RideOffer.create!(:origin => "San Jose", :destination => "Sunnyvale", :business_name => "Intel", :business_email => "jen@intel.com",
                                   :total_seat => 1, :user => @user2)

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
