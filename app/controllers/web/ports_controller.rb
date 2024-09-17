class PortsController < ApplicationController
  def index
    @ports = Ports.all
  end

  def show
    @port = Port.find(params[:id])
  end

  def new
    @port = Port.new
  end

  def create
    @port = Port.new(port_params)

    if @port.save
      flash.now[:success] = 'Created!'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def port_params
    params.require(:port).permit(:name, :rate)
  end
end
