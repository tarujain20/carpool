require 'rails_helper'

describe User, :type => :model do
  it { is_expected.to have_many(:rides).dependent(:destroy) }
  it { is_expected.to have_many(:connections).dependent(:destroy) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }

  describe "email" do
    context "case" do
      context "all lower case" do
        it "does not change the email" do
          @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
          expect(@user.email).to eq("juliar@example.com")
        end
      end

      context "not ALL lowercase" do
        it "forces email lowercase" do
          @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "JULIAr@example.com", :password => "password", :password_confirmation => "password")
          expect(@user.email).to eq("juliar@example.com")
        end
      end
    end

    context "whitespace" do
      context "no whitespace" do
        it "does not change the email" do
          @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
          expect(@user.email).to eq("juliar@example.com")
        end
      end

      context "with whitespace" do
        it "strips email whitespace" do
          @user = User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com ", :password => "password", :password_confirmation => "password")
          expect(@user.email).to eq("juliar@example.com")
        end
      end
    end
  end
end