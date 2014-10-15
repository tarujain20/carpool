require 'rails_helper'

describe HomesController, :type => :controller do
  describe "index" do
    before(:each) do
      get :index
    end

    it "requires no authentication" do
      expect(response).to be_success
    end
  end
end