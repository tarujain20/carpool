require 'rails_helper'

describe Ride, :type => :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:connections).dependent(:destroy) }

  it { should validate_presence_of(:origin) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:total_seat) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:origin_address) }
  it { should validate_presence_of(:destination_address) }
  it { should validate_presence_of(:business_name) }
  it { should validate_presence_of(:business_email) }
  it { should validate_presence_of(:commute_days) }
  it { should validate_presence_of(:leave_at) }
  it { should validate_presence_of(:return_at) }
end