class RidesController < ApplicationController
  # before_action :authenticate_user!

  def index
    find_params
    @rides = []
    if @origin && @destination
      @rides = Ride.search_by_origin_destination(@origin, @destination)
    elsif @destination
      @rides = Ride.search_by_destination(@destination)
    end
  end

  private

  def find_params
    @origin = params[:origin]
    @destination = params[:destination]
  end
end