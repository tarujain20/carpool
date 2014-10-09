require 'rails_helper'

describe Address, :type => :model do
  it { should validate_presence_of(:address_1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
end