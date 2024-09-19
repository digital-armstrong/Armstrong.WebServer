# frozen_string_literal: true

class Web::ServersController < Web::ApplicationController
  before_action :set_server, only: %i[start_polling stop_polling]

  def show; end

  def new
    @server = Server.new
  end

  def create
    @server = Server.build(server_params)

    if @server.save
      redirect_to root_path, notice: t('.success')
    else
      redirect_to root_path, alert: @server.errors.full_messages.join('. ')
    end
  end

  def start_polling
    uart = UartService.new(@server.port.name)
    uart.start_polling(@server.id)
  end

  def stop_polling
    UartService.stop_polling(@server.id)
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:name, port_attributes: %i[name rate])
  end
end
