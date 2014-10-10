require 'rails_helper'

describe "User Registration", :type => :feature do
  after(:each) do
    page.driver.delete destroy_user_session_path
  end

  describe "sign up" do
    it "allows new users to sign up with an email address and password" do
      visit new_user_registration_path
      fill_in "Email", :with => "test123@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"

      click_button "Sign up"

      expect(page).to have_content("Welcome! You have signed up successfully.")
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

  describe "sign in" do
    it "allows existing users to sign in" do
      user = User.create(:email => "test@example.com",
                         :password => "password")
      visit new_user_session_path
      fill_in "Email", :with => "test@example.com"
      fill_in "Password", :with => "password"

      click_button "Log in"

      expect(page).to have_content("Signed in successfully.")
    end
  end
end
