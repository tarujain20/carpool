class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @connections = current_user.connections
  end

  def create
    @connection = Connection.new(connection_params)
    @connection.user_id = current_user.id
    if @connection.save
      # UserMailer.send_connection_request(@ride.user.id).deliver
      # UserMailer.send_connection_request_receipt(current_user.id).deliver
      redirect_to connections_path, :notice => "Successfully added connection request."
    else
      redirect_to root_path, :notice => "#{@connection.errors.first}"
    end
  end

  def connection_params
    params.require(:connection).permit(:ride_id)
  end
end