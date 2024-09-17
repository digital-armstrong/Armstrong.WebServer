# frozen_string_literal: true

class Web::ServersController < Web::ApplicationController
  before_action :set_server, only: %i[show]

  def show; end

  def new
    @server = Server.all
  end

  def create
    @server = Server.build(server_params)

    if @server.save
      flash.now[:success] = t('.sucess')
      redirect_to root_path
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def start_polling(server_id)
    uart = UartService.new(params[:port])
    uart.start_polling(server_id)
  end

  def stop_polling
    UartService.stop_polling
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:name, port_attributes: %i[name rate])
  end
end
