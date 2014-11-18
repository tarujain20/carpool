require 'rails_helper'

describe Ride, :type => :model do
  it { should validate_presence_of(:origin) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:total_seat) }
end