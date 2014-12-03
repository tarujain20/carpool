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
    @ride.commute_days = commute_days
    if @ride.save
      # UserMailer.verify_work_email(@ride.id).deliver
      redirect_to rides_path, :notice => "Successfully added ride. Please check your work email and verify it."
    else
      flash.now[:alert] = "#{@ride.errors.first}"
      render :action => :new
    end
  end

  def edit
    find_models
  end

  def update
    find_models
    @ride.commute_days = commute_days
    if @ride.update_attributes(ride_params)
      redirect_to rides_url
    else
      flash.now[:alert] = "#{@ride.errors.first.to_s}"
      render :action => "edit"
    end
  end

  def destroy
    find_models
    @ride.destroy
    redirect_to rides_url
  end

  def verify
    find_models
    @ride.verified_business_email = true
    @ride.save
    redirect_to rides_path, :notice => "Thank you for verifying your work email!"
  end

  private

  def find_models
    @ride = Ride.where(:id => params[:id], :user_id => current_user.id).take
  end

  def find_params
    @origin = params[:ride][:origin]
    @destination = params[:ride][:destination]
  end

  def ride_params
    params.require(:ride).permit(:type, :origin, :destination, :total_seat, :business_name,
                                 :business_email, :origin_address, :destination_address, :leave_at, :return_at)
  end

  def new_ride
    ride_type = params[:ride][:type]
    if ride_type == "RideOffer"
      @ride = RideOffer.new(ride_params)
    else
      @ride = RideRequest.new(ride_params)
    end
  end

  def commute_days
    if params[:commute_days].present?
      params[:commute_days].join(" ")
    end
  end
end