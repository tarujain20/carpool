require 'rails_helper'

describe "User Registration", :type => :feature do
  after(:each) do
    page.driver.delete destroy_user_session_path
  end

  describe "sign up" do
    it "allows new users to sign up with an email address and password" do
      visit new_user_registration_path
      fill_in "First name", :with => "Jenny"
      fill_in "Last name", :with => "Doe"
      fill_in "Email", :with => "test123@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"

      click_button "Sign up"

      expect(page).to have_content("Welcome! You have signed up successfully.")
      expect(page).to have_selector('li', :text => "Jenny Doe")
    end

    context "failure" do
      it "fails if invalid email is entered" do
        visit new_user_registration_path
        fill_in "Email", :with => "test123@example"
        fill_in "Password", :with => "password"
        fill_in "Password confirmation", :with => "password"

        click_button "Sign up"

        expect(page).to have_content("Email is invalid")
      end
    end
  end

  context "existing user" do
    before(:each) do
      User.create(:first_name => "Jen", :last_name => "Doe", :email => "test@example.com", :password => "password")
      visit new_user_session_path
      fill_in "Email", :with => "test@example.com"
      fill_in "Password", :with => "password"

      click_button "Log in"
    end

    describe "sign in" do
      it "allows to sign in" do
        expect(page).to have_content("Signed in successfully.")
      end
    end

    describe "edit" do
      it "allows editing fields" do
        # visit edit_user_registration_path
        click_link "Jen Doe"
        fill_in "First name", :with => "JenEdit"
        fill_in "Current password", :with => "password"

        click_button "Update"

        expect(page).to have_content("Your account has been updated successfully.")
        expect(page).to have_selector('li', :text => "JenEdit Doe")
      end
    end
  end
end
