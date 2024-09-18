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
      redirect_to root_path, notice: t('.success')
    else
      redirect_to root_path, alert: @server.errors.full_messages.join('. ')
    end
  end

  def start_polling
    server = Server.find(params[:id])
    uart = UartService.new(server.port.name)
    uart.start_polling(server.id)
  end

  def pause_polling
    server = Server.find(params[:id])
    UartService.pause_polling(server.id)
  end

  def stop_polling
    server = Server.find(params[:id])
    UartService.stop_polling(server.id)
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:name, port_attributes: %i[name rate])
  end
end
