require 'rails_helper'

describe Address, :type => :model do
  it { should validate_presence_of(:city) }
end