class RidesController < ApplicationController
  before_action :authenticate_user!

  def index
    @rides = current_user.rides.order("type")
  end

  def search
    find_params
    @rides = []
    if @origin.present? && @destination.present?
      @rides = Ride.search_by_origin_destination(@origin, @destination)
    elsif @destination.present?
      @rides = Ride.search_by_destination(@destination)
    end
  end

  def new
    @ride = Ride.new
  end

  def create
    @ride = new_ride
    @ride.user_id = current_user.id
    if @ride.save
      redirect_to rides_url(:ride => {:destination => @ride.destination}), :notice => "Successfully added ride."
    else
      flash.now[:alert] = "#{@ride.errors.first}"
      render :action => :new
    end
  end

  private

  def find_params
    @origin = params[:ride][:origin]
    @destination = params[:ride][:destination]
  end

  def ride_params
    params.require(:ride).permit(:type, :origin, :destination, :total_seat, :business_name, :business_email)
  end

  def new_ride
    ride_type = params[:ride][:type]
    if ride_type == "RideOffer"
      @ride = RideOffer.new(ride_params)
    else
      @ride = RideRequest.new(ride_params)
    end
  end
end