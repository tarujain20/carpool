class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @connections = current_user.connections
  end

  def create
    @connection = Connection.new(connection_params)
    @connection.user_id = current_user.id
    if @connection.save
        redirect_to connections_path, :notice => "Successfully added connection request."
    else
      redirect_to root_path, :notice => "#{@connection.errors.first}"
    end
  end

  def connection_params
    params.require(:connection).permit(:ride_id)
  end
end